local wezterm = require 'wezterm';

local config = {
    color_scheme = "tokyonight",
    window_background_opacity = 0.95,
    tab_bar_at_bottom = true,
    use_fancy_tab_bar = false,
    enable_scroll_bar = true,
    use_ime = true,
    adjust_window_size_when_changing_font_size = false,

    audible_bell = "Disabled",

    -- Custom color echeme
    colors = {
        scrollbar_thumb = "WHITE",
    },

    -- Initial window size on startup
    initial_rows = 28,
    initial_cols = 100,

    -- Window Padding
    window_padding = {
        right  = 16, -- Scroll bar width
        top    = 0,
        bottom = 0,
    },

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
        { key = "LeftArrow",  mods = "ALT", action = wezterm.action.AdjustPaneSize { "Left" , 2 } },
        { key = "DownArrow",  mods = "ALT", action = wezterm.action.AdjustPaneSize { "Down" , 2 } },
        { key = "UpArrow",    mods = "ALT", action = wezterm.action.AdjustPaneSize { "Up"   , 2 } },
        { key = "RightArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize { "Right", 2 } },

        -- Window Scrolling
        { key = 'j', mods = 'ALT', action = wezterm.action.ScrollByLine(2) },
        { key = 'k', mods = 'ALT', action = wezterm.action.ScrollByLine(-2) },

        -- Copy text
        { key = "c", mods = "CTRL|SHIFT", action = "Copy" },

        -- Launch menu for launcher
        { key = "l", mods = "ALT", action = wezterm.action.ShowLauncherArgs { flags = "LAUNCH_MENU_ITEMS" } },

        -- Launch menu for tabs
        { key = "9", mods = "ALT", action = wezterm.action.ShowLauncherArgs { flags = "TABS" } },
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

-- Only show tab_index in tab bar
wezterm.on(
    "format-tab-title",
    function(tab)
        local title = ' ' .. tab.tab_index .. ' '
        return {
            { Text = title },
        }
    end
)

local launch_menu = {}

-- Switch configuration depends on OS
if wezterm.target_triple == "x86_64-pc-windows-msvc" then

    config.window_padding.right = 10

    config.default_prog = { 'pwsh.exe', '-NoLogo' }

    config.font = wezterm.font("Consolas")
    config.font_size = 13
    -- config.font = wezterm.font_with_fallback({ "Cascadia Mono", "BIZ UDGothic" })
    -- config.font_size = 12

    -- Setup lanch menu
    table.insert(launch_menu, {
        label = "pwsh",
        args  = { "pwsh.exe", "-NoLogo" },
    })

    -- Enumerate any WSL distributions that are installed and add those to the menu
    local _, wsl_list, _ = wezterm.run_child_process { 'wsl.exe', '-l' }
    -- https://github.com/microsoft/WSL/issues/4607
    wsl_list = wezterm.utf16_to_utf8(wsl_list)

    for idx, line in ipairs(wezterm.split_by_newlines(wsl_list)) do
        if idx > 1 then
            local distro = line:gsub("%(.*%)", "")
            -- List WSL distributions except Docker
            if not(string.match(distro, "docker.*")) then
                table.insert(launch_menu, {
                    label = "WSL " .. distro,
                    args  = { "pwsh.exe", "-NoLogo", "-NoProfile", "-Command" , "wsl.exe", "-d", distro },
                })
            end
        end
    end

    config.launch_menu = launch_menu

elseif wezterm.target_triple == "x86_64-apple-darwin" then
    config.default_prog = { 'zsh', '--login' }
    config.font = wezterm.font("Sarasa Fixed J")
    config.font_size = 20
    config.line_height = 1.0
else
    config.default_prog = { 'zsh', '--login' }
    config.font = wezterm.font("Cascadia Mono")
    config.font_size = 12
end

return config
