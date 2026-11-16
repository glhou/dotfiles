-- Workspace (session) switcher for WezTerm, powered by fzf.
--
-- LEADER+s opens fzf in a split at the bottom listing your workspaces.
--   Enter   -> switch to the highlighted workspace; if nothing matches what you
--              typed, create a workspace with that name
--   Ctrl-n  -> create a workspace named exactly what you typed (even if other
--              workspaces fuzzy-match it, e.g. "foo" while "foobar" exists)
--   Esc     -> cancel
--
-- fzf reports its choice back to WezTerm through an OSC 1337 SetUserVar escape,
-- which fires the `user-var-changed` event handled below.
--
-- Usage (wezterm.lua):
--   local switcher = wezterm.plugin.require 'https://github.com/<you>/<repo>'
--   switcher.apply_to_config(config, { key = 's', mods = 'LEADER' })
--
-- Options: key, mods, size_percent (default 40), fzf_path (extra dir for PATH)

local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local USER_VAR = "workspace_switch"

local SCRIPT = [==[
command -v fzf >/dev/null 2>&1 || { echo "fzf not found in PATH"; read -r _; exit 1; }
out=$(printf '%s\n' "$@" | fzf --print-query --expect=ctrl-n \
  --prompt='workspace> ' \
  --header='enter: switch / create   ctrl-n: create typed name' \
  --reverse --height=100%)
rc=$?
[ "$rc" -eq 130 ] && exit 0
query=$(printf '%s\n' "$out" | sed -n 1p)
key=$(printf '%s\n' "$out" | sed -n 2p)
sel=$(printf '%s\n' "$out" | sed -n 3p)
if [ "$key" = "ctrl-n" ] && [ -n "$query" ]; then
  name=$query
elif [ -n "$sel" ]; then
  name=$sel
elif [ -n "$query" ]; then
  name=$query
else
  exit 0
fi
enc=$(printf '%s' "$name" | base64 | tr -d '\n')
printf '\033]1337;SetUserVar=%s=%s\007' workspace_switch "$enc"
]==]

-- Action to bind to a key: opens the fzf picker.
function M.switch(opts)
	opts = opts or {}
	return wezterm.action_callback(function(window, pane)
		local names = wezterm.mux.get_workspace_names()
		table.sort(names)

		local args = { "/bin/sh", "-c", SCRIPT, "workspace_switcher" }
		for _, n in ipairs(names) do
			table.insert(args, n)
		end

		-- GUI-launched WezTerm on macOS has a minimal PATH; add Homebrew locations.
		local path = table.concat({
			opts.fzf_path or "",
			"/opt/homebrew/bin",
			"/usr/local/bin",
			os.getenv("PATH") or "/usr/bin:/bin",
		}, ":")

		window:perform_action(
			act.SplitPane({
				direction = "Down",
				top_level = true,
				size = { Percent = opts.size_percent or 40 },
				command = {
					args = args,
					set_environment_variables = { PATH = path },
				},
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
		action = M.switch(opts),
	})

	wezterm.on("user-var-changed", function(window, _pane, name, value)
		if name ~= USER_VAR or not value or value == "" then
			return
		end
		-- Give the fzf pane a moment to close, then switch from the live pane.
		wezterm.time.call_after(0.05, function()
			window:perform_action(act.SwitchToWorkspace({ name = value }), window:active_pane())
		end)
	end)
end

return M
