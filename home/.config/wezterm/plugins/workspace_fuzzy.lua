-- Workspace (session) switcher for WezTerm.
--
-- LEADER+s, type to fuzzy-filter your workspaces, Enter to go.
--   * Enter with a name that matches no existing workspace creates it.
--   * Up/Down (or Ctrl-n/Ctrl-p) pick one of the matches explicitly.
--   * Esc / Ctrl-c cancels.
--
-- The picker is drawn in the left status area of the tab bar, because WezTerm's
-- built-in InputSelector can't return free-typed text.
--
-- Usage (wezterm.lua):
--   local switcher = wezterm.plugin.require 'https://github.com/<you>/<repo>'
--   switcher.apply_to_config(config, { key = 's', mods = 'LEADER' })
--
-- Local usage: save as ~/.config/wezterm/workspace_switcher.lua and
--   package.path = wezterm.config_dir .. '/?.lua;' .. package.path
--   local switcher = require 'workspace_switcher'

local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local TABLE = "workspace_switcher"
local MAX_VISIBLE = 8

-- Active picker state (nil when closed).
local S = nil

---------------------------------------------------------------------------
-- Matching
---------------------------------------------------------------------------

-- Lower score = better. nil = no match.
local function score(name, q)
	if q == "" then
		return 0
	end
	local idx = name:find(q, 1, true)
	if idx then
		return idx -- substring match, earlier is better
	end
	local pos, first = 1, nil
	for c in q:gmatch(".") do
		local f = name:find(c, pos, true)
		if not f then
			return nil
		end
		first = first or f
		pos = f + 1
	end
	return 1000 + (pos - first) -- subsequence match, tighter is better
end

local function recompute()
	local q = S.query:lower()
	local found = {}
	S.exact = false
	for _, name in ipairs(S.names) do
		if name == S.query then
			S.exact = true
		end
		local sc = score(name:lower(), q)
		if sc then
			table.insert(found, { name = name, score = sc })
		end
	end
	table.sort(found, function(a, b)
		if a.score ~= b.score then
			return a.score < b.score
		end
		return a.name < b.name
	end)
	S.matches = {}
	for _, f in ipairs(found) do
		table.insert(S.matches, f.name)
	end
	if S.sel and S.sel > #S.matches then
		S.sel = (#S.matches > 0) and #S.matches or nil
	end
end

---------------------------------------------------------------------------
-- Rendering
---------------------------------------------------------------------------

local function render(window)
	if not S then
		window:set_left_status("")
		return
	end

	local out = {
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { AnsiColor = "Aqua" } },
		{ Text = " workspace> " },
		{ Foreground = { AnsiColor = "White" } },
		{ Text = S.query .. "█  " },
		"ResetAttributes",
	}

	local first = 1
	if S.sel and S.sel > MAX_VISIBLE then
		first = S.sel - MAX_VISIBLE + 1
	end
	local last = math.min(#S.matches, first + MAX_VISIBLE - 1)

	for i = first, last do
		local name = S.matches[i]
		local label = " " .. name .. (name == S.current and "*" or "") .. " "
		if i == S.sel then
			table.insert(out, { Background = { AnsiColor = "Blue" } })
			table.insert(out, { Foreground = { AnsiColor = "White" } })
			table.insert(out, { Text = label })
			table.insert(out, "ResetAttributes")
		else
			table.insert(out, { Text = label })
		end
	end
	if last < #S.matches then
		table.insert(out, { Text = (" +%d more "):format(#S.matches - last) })
	end

	local hint
	if S.sel then
		hint = "↵ switch"
	elseif S.query == "" then
		hint = ""
	elseif S.exact then
		hint = "↵ switch"
	else
		hint = ('↵ create "%s"'):format(S.query)
	end
	if hint ~= "" then
		table.insert(out, { Foreground = { AnsiColor = "Yellow" } })
		table.insert(out, { Text = " " .. hint .. " " })
		table.insert(out, "ResetAttributes")
	end

	window:set_left_status(wezterm.format(out))
end

local function refresh(window)
	recompute()
	render(window)
end

---------------------------------------------------------------------------
-- Actions
---------------------------------------------------------------------------

local function close(window, pane)
	S = nil
	window:set_left_status("")
	window:perform_action(act.PopKeyTable, pane)
end

local function type_char(ch)
	return wezterm.action_callback(function(window, _pane)
		if not S then
			return
		end
		S.query = S.query .. ch
		S.sel = nil
		refresh(window)
	end)
end

local backspace = wezterm.action_callback(function(window, _pane)
	if not S or S.query == "" then
		return
	end
	-- drop the last UTF-8 character
	S.query = S.query:gsub("[%z\1-\127\194-\244][\128-\191]*$", "")
	S.sel = nil
	refresh(window)
end)

local clear_query = wezterm.action_callback(function(window, _pane)
	if not S then
		return
	end
	S.query = ""
	S.sel = nil
	refresh(window)
end)

local move_down = wezterm.action_callback(function(window, _pane)
	if not S or #S.matches == 0 then
		return
	end
	S.sel = S.sel and math.min(S.sel + 1, #S.matches) or 1
	render(window)
end)

local move_up = wezterm.action_callback(function(window, _pane)
	if not S then
		return
	end
	if S.sel then
		S.sel = (S.sel > 1) and (S.sel - 1) or nil
	end
	render(window)
end)

local cancel = wezterm.action_callback(function(window, pane)
	if S then
		close(window, pane)
	end
end)

local confirm = wezterm.action_callback(function(window, pane)
	if not S then
		return
	end
	local query = S.query:gsub("^%s+", ""):gsub("%s+$", "")
	local target
	if S.sel then
		target = S.matches[S.sel]
	elseif query ~= "" then
		target = query -- existing workspace with that exact name, or a new one
	end
	close(window, pane)
	if target then
		window:perform_action(act.SwitchToWorkspace({ name = target }), pane)
	end
end)

---------------------------------------------------------------------------
-- Public API
---------------------------------------------------------------------------

-- Action to bind to a key: opens the picker.
function M.switch()
	return wezterm.action_callback(function(window, pane)
		local names = wezterm.mux.get_workspace_names()
		table.sort(names)
		S = {
			query = "",
			sel = nil,
			names = names,
			current = window:active_workspace(),
			matches = {},
			exact = false,
		}
		refresh(window)
		window:perform_action(
			act.ActivateKeyTable({
				name = TABLE,
				one_shot = false,
				replace_current = true,
				prevent_fallback = true,
			}),
			pane
		)
	end)
end

local function build_key_table()
	local keys = {}
	local function add(key, mods, action)
		table.insert(keys, { key = key, mods = mods, action = action })
	end

	-- letters
	for c in ("abcdefghijklmnopqrstuvwxyz"):gmatch(".") do
		local up = c:upper()
		add(c, "NONE", type_char(c))
		add(c, "SHIFT", type_char(up))
		add(up, "NONE", type_char(up))
		add(up, "SHIFT", type_char(up))
	end
	-- digits
	for c in ("0123456789"):gmatch(".") do
		add(c, "NONE", type_char(c))
	end
	-- punctuation useful in names
	for c in (".:/@+"):gmatch(".") do
		add(c, "NONE", type_char(c))
		add(c, "SHIFT", type_char(c))
	end
	add("-", "NONE", type_char("-"))
	add("-", "SHIFT", type_char("_"))
	add("_", "NONE", type_char("_"))
	add("_", "SHIFT", type_char("_"))
	add("Space", "NONE", type_char(" "))

	-- editing / navigation
	add("Backspace", "NONE", backspace)
	add("u", "CTRL", clear_query)
	add("w", "CTRL", clear_query)
	add("DownArrow", "NONE", move_down)
	add("n", "CTRL", move_down)
	add("UpArrow", "NONE", move_up)
	add("p", "CTRL", move_up)
	add("Enter", "NONE", confirm)
	add("Escape", "NONE", cancel)
	add("c", "CTRL", cancel)

	return keys
end

function M.apply_to_config(config, opts)
	opts = opts or {}
	config.keys = config.keys or {}
	table.insert(config.keys, {
		key = opts.key or "s",
		mods = opts.mods or "LEADER",
		action = M.switch(),
	})
	config.key_tables = config.key_tables or {}
	config.key_tables[TABLE] = build_key_table()
	config.enable_tab_bar = config.enable_tab_bar ~= false
end

return M
