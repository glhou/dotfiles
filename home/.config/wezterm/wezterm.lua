local wezterm = require("wezterm") ---@type Wezterm
local config = wezterm.config_builder() ---@type Config
local act = wezterm.action

config.automatically_reload_config = false

config.font_size = 16
config.color_scheme = "Catppuccin Latte"
config.font = wezterm.font("FiraCode Nerd Font SemBd")

config.tab_bar_at_bottom = true

config.window_padding = {
	left = "0.25cell",
	right = 0,
	top = 0,
	bottom = 0,
}
config.inactive_pane_hsb = {
	saturation = 1.0,
	brightness = 1.0,
}

-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, pane)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name
	end
	window:set_right_status(name or "")
end)

wezterm.on("update-left-status", function(window, pane)
  local workspace_name = window:mux_window():get_workspace()
end

config.leader = { key = "b", mods = "CTRL" }
config.keys = {
	{
		key = "p",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "prefix_p",
			one_shot = true,
		}),
	},
	{
		key = "t",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "prefix_t",
			one_shot = true,
		}),
	},
	{
		key = "o",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "prefix_o",
			one_shot = true,
		}),
	},
	{
		key = "l",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "h",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "z",
		mods = "LEADER",
		action = act.TogglePaneZoomState,
	},
	{
		key = "s",
		mods = "LEADER",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
}

for i = 0, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i),
	})
end

config.key_tables = {
	prefix_p = {
		{
			key = "n",
			mods = "NONE",
			action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "x",
			mods = "NONE",
			action = act.CloseCurrentPane({ confirm = false }),
		},
	},
	prefix_t = {
		{
			key = "n",
			mods = "NONE",
			action = act.SpawnTab("CurrentPaneDomain"),
		},
		{
			key = "x",
			mods = "NONE",
			action = act.CloseCurrentTab({ confirm = true }),
		},
		{
			key = "r",
			mods = "NONE",
			action = act.PromptInputLine({
				description = "Enter new name for tab",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
	},
	prefix_o = {
		{
			key = "d",
			mods = "NONE",
			action = act.SwitchToWorkspace({ name = "default" }),
		},
		{
			key = "r",
			mods = "NONE",
			action = act.PromptInputLine({
				description = "Enter new name for session",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						wezterm.mux.rename_workspace(window:mux_window():get_workspace(), line)
					end
				end),
			}),
		},
	},
}

return config
