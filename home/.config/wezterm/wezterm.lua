local wezterm = require("wezterm")

local config = {
    -----------------------
    -- GUI Customization --
    -----------------------
    color_scheme = "Kanagawa (Gogh)",
    window_background_opacity = 0.9,
    tab_bar_at_bottom = true,
    use_fancy_tab_bar = false,
    tab_max_width = 25,
    -- Initial window size on startup
    initial_rows = 32,
    initial_cols = 100,
    -- Window Padding for scrollbar
    window_padding = { right = 10, top = 0, bottom = 0 },
    -- Scrollbar Appearance
    enable_scroll_bar = true,
    colors = { scrollbar_thumb = "Gray" },
    -- Reverse Curor Colors
    force_reverse_video_cursor = true,
    font = wezterm.font_with_fallback({ "consolas", "BIZ UDGothic", "Symbols Nerd Font Mono" }),
    harfbuzz_features = { "" },
    cell_width = 1.0,
    -- Pane appearance
    inactive_pane_hsb = {
        saturation = 0.5,
        brightness = 0.8,
    },
    -----------------------
    -- App Configuration --
    -----------------------
    use_ime = true,
    audible_bell = "Disabled",
    -- Check Update manually
    check_for_updates = false,
    adjust_window_size_when_changing_font_size = false,
    ------------------
    -- Key bindings --
    ------------------
    leader = { key = "b", mods = "CTRL" },
    keys = {
        -- Key bindings for tab operation
        { key = "w", mods = "LEADER", action = "ShowTabNavigator" },
        { key = "[", mods = "ALT", action = wezterm.action.ActivateTabRelativeNoWrap(-1) },
        { key = "]", mods = "ALT", action = wezterm.action.ActivateTabRelativeNoWrap(1) },
        { key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
        { key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },

        -- Key bindings for pane operation
        { key = "h", mods = "ALT", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
        { key = "v", mods = "ALT", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
        { key = "w", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Next") },
        { key = "LeftArrow",  mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Left", 2 }) },
        { key = "DownArrow",  mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Down", 2 }) },
        { key = "UpArrow",    mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Up", 2 }) },
        { key = "RightArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Right", 2 }) },

        -- Window Scrolling
        { key = "j", mods = "ALT", action = wezterm.action.ScrollByLine(2) },
        { key = "k", mods = "ALT", action = wezterm.action.ScrollByLine(-2) },
        { key = "j", mods = "ALT|SHIFT", action = wezterm.action.ScrollByPage(0.5) },
        { key = "k", mods = "ALT|SHIFT", action = wezterm.action.ScrollByPage(-0.5) },

        -- Copy text
        { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("ClipboardAndPrimarySelection") },

        -- Launch menu for launcher
        { key = "l", mods = "ALT", action = wezterm.action.ShowLauncherArgs({ flags = "LAUNCH_MENU_ITEMS" }), },

        -- Launch menu for tabs
        { key = "9", mods = "ALT", action = wezterm.action.ShowLauncherArgs({ flags = "TABS" }) },
        { key = "n", mods = "LEADER", action = wezterm.action.ToggleFullScreen },
    },
    mouse_bindings = {
        -- Right-Click will open the link under the mouse cursor
        { event = { Up   = { streak = 1, button = "Right" } }, action = wezterm.action.OpenLinkAtMouseCursor, },
        -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
        { event = { Down = { streak = 1, button = "Left"  } }, mods = "CTRL", action = wezterm.action.Nop, },
        -- Disable open the link with only Left-Click
        { event = { Up   = { streak = 1, button = "Left"  } }, mods = "", action = wezterm.action.Nop, },
    },
}

-- Switch configuration depends on operating system
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = { "pwsh.exe", "-NoLogo" }
    config.initial_rows = 42
    config.initial_cols = 140
    config.font_size = 14
    config.line_height = 1.2

    -- Add PowerShell to launch menu
    local launch_menu = {}
    table.insert(launch_menu, { label = "pwsh", args = { "pwsh.exe", "-NoLogo" } })

    -- Enumerate any WSL distributions that are installed and add those to the menu
    local _, wsl_list, _ = wezterm.run_child_process({ "wsl.exe", "-l" })
    -- https://github.com/microsoft/WSL/issues/4607
    wsl_list = wezterm.utf16_to_utf8(wsl_list)
    for idx, line in ipairs(wezterm.split_by_newlines(wsl_list)) do
        if idx > 1 then
            local distro = line:gsub("%(.*%)", "")
            -- List WSL distributions except Docker
            if not (string.match(distro, "docker.*")) then
                table.insert(launch_menu, {
                    label = "WSL " .. distro,
                    args = { "pwsh.exe", "-NoLogo", "-NoProfile", "-Command", "wsl.exe", "-d", distro },
                })
            end
        end
    end
    config.launch_menu = launch_menu
elseif wezterm.target_triple == "x86_64-apple-darwin" then
    -- https://github.com/wez/wezterm/issues/2669
    -- config.window_background_opacity = 0.9999
    config.window_background_opacity = 0.9
    config.default_prog = { "zsh", "--login" }
    config.font_size = 17
    config.line_height = 1.0
    config.window_padding.right = 16 -- Scrollbar width
else
    config.default_prog = { "zsh", "--login" }
    config.font_size = 16
    config.line_height = 1.0
    config.enable_wayland = false
    config.window_decorations = "TITLE | RESIZE"
end

return config
