local wezterm = require 'wezterm';

local config = {
    color_scheme = "Gruvbox Dark",
    window_background_opacity = 0.95,
    tab_bar_at_bottom = true,
    use_fancy_tab_bar = false,
    use_ime = true,

    -- Initial window size on startup
    initial_rows = 28,
    initial_cols = 100,

    -- pane appearance
    inactive_pane_hsb = {
        saturation = 0.8,
        brightness = 0.4,
    },

    -- Key bindings
    leader  = { key = "b", mods = "CTRL" },
    keys = {
        -- Key bindings for tab operation
        { key = "w", mods = "LEADER", action = "ShowTabNavigator" },
        { key = "[", mods = "ALT", action = wezterm.action.ActivateTabRelativeNoWrap(-1) },
        { key = "]", mods = "ALT", action = wezterm.action.ActivateTabRelativeNoWrap(1) },
        { key = "c", mods = "LEADER", action = wezterm.action { SpawnTab = "CurrentPaneDomain" }},
        { key = "x", mods = "LEADER", action = wezterm.action { CloseCurrentTab = { confirm = true }}},

        -- Key bindings for pane operation
        { key = "h", mods = "ALT", action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" }}},
        { key = "v", mods = "ALT", action = wezterm.action { SplitVertical   = { domain = "CurrentPaneDomain" }}},
        { key = "w", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Next") },

        -- Copy text
        { key = "c", mods = "CTRL|SHIFT", action = "Copy" },
    },
    mouse_bindings = {
        -- Ctrl-click will open the link under the mouse cursor
        {
            event  = { Up = { streak = 1, button = "Left" } },
            mods   = "CTRL",
            action = wezterm.action.OpenLinkAtMouseCursor,
        },
        -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
        {
            event  = { Down = { streak = 1, button = "Left" } },
            mods   = "CTRL",
            action = wezterm.action.Nop,
        },
        -- Disable open the link with only left click
        {
            event  = { Up = { streak = 1, button = "Left" } },
            mods   = "",
            action = wezterm.action.Nop,
        }
    },
}

-- Only show tab_id in tab bar
wezterm.on("format-tab-title", function(tab)
    local title = " " .. tab.tab_id .. " "
    return {
        { Text = title },
    }
end)

-- Switch configuration depends on OS
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = { 'pwsh.exe', '-NoLogo' }
    config.font = wezterm.font_with_fallback({
        "UDEV Gothic"
    })
    config.font_size = 13
elseif wezterm.target_triple == "x86_64-apple-darwin" then
    config.default_prog = { 'zsh', '--login' }
    config.font = wezterm.font("SF Mono Square")
    config.font_size = 22
else
    config.default_prog = { 'zsh', '--login' }
end

return config
