-- Workspace fuzzy switcher for WezTerm.
-- Fuzzy-find among existing workspaces (sessions) or create a new one.
--
-- Usage (wezterm.lua):
--   local switcher = wezterm.plugin.require 'https://github.com/<you>/<repo>'
--   switcher.apply_to_config(config, { key = 's', mods = 'LEADER' })
--
-- Local usage: put this file at ~/.config/wezterm/plugins/workspace_switcher.lua
-- and `package.path = wezterm.config_dir .. '/plugins/?.lua;' .. package.path`
-- then `local switcher = require 'workspace_switcher'`.

local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local NEW_ID = "__new_workspace__"

local function switch_to(window, pane, name)
	window:perform_action(act.SwitchToWorkspace({ name = name }), pane)
end

local function prompt_new(window, pane)
	window:perform_action(
		act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Text = "New workspace name:" },
			}),
			action = wezterm.action_callback(function(w, p, line)
				if line and line ~= "" then
					switch_to(w, p, line)
				end
			end),
		}),
		pane
	)
end

-- Returns an action you can bind to a key.
function M.switch()
	return wezterm.action_callback(function(window, pane)
		local current = window:active_workspace()
		local names = wezterm.mux.get_workspace_names()
		table.sort(names)

		local choices = {}
		for _, name in ipairs(names) do
			local label = name
			if name == current then
				label = name .. "  (current)"
			end
			table.insert(choices, { id = name, label = label })
		end

		window:perform_action(
			act.InputSelector({
				title = "Workspaces",
				description = "Type to filter, Enter to switch, Esc to cancel",
				fuzzy = true,
				fuzzy_description = "Workspace: ",
				choices = choices,
				action = wezterm.action_callback(function(w, p, id, _label)
					if not id then
						prompt_new(w, p)
					else
						switch_to(w, p, id)
					end
				end),
			}),
			pane
		)
	end)
end

function M.apply_to_config(config, opts)
	opts = opts or {}
	config.keys = config.keys or {}
	table.insert(config.keys, {
		key = opts.key or "s",
		mods = opts.mods or "LEADER",
		action = M.switch(),
	})
end

return M
