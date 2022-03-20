local wezterm = require 'wezterm';

local shell;
local font_profile;

if os.getenv('windir') then
  shell = { 'pwsh.exe', '-NoLogo' }
  font_profile = wezterm.font_with_fallback({
    "Consolas",
    "Rounded Mplus 1c"
  })
else
  shell = { 'zsh', '--login' }
  font_profile = wezterm.font("SF Mono Square")
end

return {
  color_scheme = 'Gruvbox Dark',
  window_background_opacity = 0.9,
  tab_bar_at_bottom = true,

  use_fancy_tab_bar =false,

  -- 起動時のウィンドウサイズ (文字数)
  initial_rows = 25,
  initial_cols = 100,

  -- font
  font = font_profile,
  font_size = 18,
  line_height = 1.0,
  use_ime = true,

  default_prog = shell,
}
