local M = {}

local wsl_distros = {
  fedora = "linux_fedora",
  kali = "linux_kali_linux",
  nixos = "linux_nixos",
  ubuntu = "linux_ubuntu",
}

local function get_shell_icon(wezterm, pane_info)
  local domain_name = pane_info.domain_name or ""

  if not domain_name:match("^WSL:") then
    return wezterm.nerdfonts.md_powershell
  end

  local domain_name_lower = domain_name:lower()
  for distro, icon_name in pairs(wsl_distros) do
    if domain_name_lower:match(distro) then
      return wezterm.nerdfonts[icon_name]
    end
  end

  return wezterm.nerdfonts.linux_tux
end

function M.format_tab_title(wezterm, tab, max_width)
  local pane_info = tab.active_pane
  local process_name = pane_info.title ~= "" and pane_info.title ~= "wezterm" and pane_info.title or "shell"
  local title = string.format("  %s  %s ", get_shell_icon(wezterm, pane_info), process_name)

  if max_width then
    title = wezterm.truncate_right(title, max_width)
  end

  return {
    { Text = title },
  }
end

return M
