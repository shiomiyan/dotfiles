local wezterm = require 'wezterm';

local config = {
    color_scheme = "Gruvbox Dark",
    window_background_opacity = 0.95,
    tab_bar_at_bottom = true,
    use_fancy_tab_bar = false,
    use_ime = true,

    -- 起動時のウィンドウサイズ (文字数)
    initial_rows = 28,
    initial_cols = 100,

    -- pane appearance
    inactive_pane_hsb = {
        saturation = 0.8,
        brightness = 0.4,
    },

    -- Key bindings
    leader  = { key = "b", mods = "CTRL" },
    keys    = {
        { key = "w", mods = "LEADER", action = "ShowTabNavigator" },
        { key = "c", mods = "LEADER", action = wezterm.action { SpawnTab = "CurrentPaneDomain" }},
        { key = "x", mods = "LEADER", action = wezterm.action { CloseCurrentTab = { confirm = true }}},
        { key = "h", mods = "LEADER", action = wezterm.action { SplitHorizontal = { domain= "CurrentPaneDomain" }}},
        { key = "C", mods = "CTRL|SHIFT", action = "Copy" },
    }
}


if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.shell = { 'pwsh.exe', '-NoLogo' }
    config.font = wezterm.font_with_fallback({
        "Consolas",
        "Cica"
    })
    config.font_size = 13
elseif wezterm.target_triple == "x86_64-apple-darwin" then
    config.shell = { 'zsh', '--login' }
    config.font = wezterm.font("SF Mono Square")
    config.font_size = 22
else
    config.shell = { 'zsh', '--login' }
end


return config
