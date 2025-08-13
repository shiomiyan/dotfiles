local wezterm = require("wezterm")
local config = wezterm.config_builder()

-----------------------
-- GUI Customization --
-----------------------
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.9
config.kde_window_background_blur = true
config.tab_bar_at_bottom = true
config.tab_max_width = 25

-- Custom font for fancy tab
config.window_frame = {
  font = require('wezterm').font 'Lato',
  font_size = 12,
}

-- Initial window size on startup
config.initial_rows = 32
config.initial_cols = 100

-- Window Padding for scrollbar
config.window_padding = { right = 10, top = 0, bottom = 0 }

-- Scrollbar Appearance
config.enable_scroll_bar = true
config.colors = { scrollbar_thumb = "Gray" }

-- Reverse Curor Colors
config.force_reverse_video_cursor = true
config.font = wezterm.font_with_fallback({ "Cica", "Symbols Nerd Font Mono" })

-- Pane appearance
config.inactive_pane_hsb = {
    saturation = 0.5,
    brightness = 0.8,
}

-----------------------
-- App Configuration --
-----------------------
config.use_ime = true
config.audible_bell = "Disabled"

-- Check Update manually
config.check_for_updates = false
config.adjust_window_size_when_changing_font_size = false

------------------
-- Key bindings --
------------------
config.keys = {
    -- Copy text
    { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("ClipboardAndPrimarySelection") },
}

config.mouse_bindings = {
    -- Right-Click will open the link under the mouse cursor
    { event = { Up   = { streak = 1, button = "Right" } }, action = wezterm.action.OpenLinkAtMouseCursor, },

    -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
    { event = { Down = { streak = 1, button = "Left" } }, mods = "CTRL", action = wezterm.action.Nop, },

    -- Disable open the link with only Left-Click
    { event = { Up   = { streak = 1, button = "Left" } }, mods = "", action = wezterm.action.Nop, },
}

-- Switch configuration depends on operating system
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = { "pwsh.exe", "-NoLogo" }
    config.initial_rows = 42
    config.initial_cols = 140
    config.font_size = 14
elseif wezterm.target_triple == "x86_64-apple-darwin" then
    config.default_prog = { "zsh", "--login" }
    -- https://github.com/wez/wezterm/issues/2669
    config.window_background_opacity = 0.9999
    config.font_size = 16
    config.window_padding.right = 16 -- Scrollbar width
else
    config.default_prog = { "zsh", "--login" }
    config.font_size = 12
    config.enable_wayland = false
    config.window_decorations = "TITLE | RESIZE"
end

return config
