local wezterm = require 'wezterm';

local shell;
local font;
local font_size;

if os.getenv('windir') then
  shell = { 'pwsh.exe', '-NoLogo' }
  font = wezterm.font_with_fallback({
    "Consolas",
    -- "Rounded Mplus 1c"
    "UDEV Gothic NF"
  })
  font_size = 13
else
  shell = { 'zsh', '--login' }
  font = wezterm.font("SF Mono Square")
  font_size = 22
end

return {
  color_scheme = 'Gruvbox Dark',
  window_background_opacity = 0.95,
  tab_bar_at_bottom = true,
  use_fancy_tab_bar =false,

  -- 起動時のウィンドウサイズ (文字数)
  initial_rows = 28,
  initial_cols = 100,

  -- font
  font = font,
  font_size = font_size,
  line_height = 1.0,
  use_ime = true,

  default_prog = shell,

  -- Key bindings
  leader  = { key = "b", mods = "CTRL" },
  keys    = {
    { key = "w", mods = "LEADER", action = "ShowTabNavigator" },
    { key = "c", mods = "LEADER", action = wezterm.action { SpawnTab = "CurrentPaneDomain" }},
    { key = "x", mods = "LEADER", action = wezterm.action { CloseCurrentTab = { confirm = true }}}
  }
}
