local wezterm = require 'wezterm';

return {
  color_scheme = "Gruvbox Dark";
  window_background_opacity = 0.9;
  tab_bar_at_bottom = true;

  use_fancy_tab_bar =false;

  -- 起動時のウィンドウサイズ (文字数)
  initial_rows = 25;
  initial_cols = 100;

  -- font
  font = wezterm.font_with_fallback({
    "M+ 1mn",
    "FirgeNerd Console"
  });
  font_size = 12;
  line_height = 0.8;
  use_ime = true;

  default_prog = { 'pwsh.exe', '-NoLogo' };
}