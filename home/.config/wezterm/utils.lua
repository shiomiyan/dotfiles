local M = {}

function M.basename(path)
  if not path or path == "" then
    return nil
  end

  return path:gsub("\\", "/"):match("([^/]+)$")
end

function M.strip_extension(name)
  if not name then
    return nil
  end

  return name:gsub("%.exe$", "")
end

function M.get_title_text(pane_info)
  local title = pane_info.title
  if title and title ~= "" and title ~= "wezterm" then
    return title
  end

  return nil
end

function M.get_display_process_name(pane_info)
  return M.get_title_text(pane_info) or "shell"
end

function M.get_shell_kind(pane_info)
  local domain_name = pane_info.domain_name or ""
  local domain_name_lower = domain_name:lower()

  if not domain_name:match("^WSL:") then
    return "pwsh"
  end

  if domain_name_lower:match("fedora") then
    return "wsl-fedora"
  end

  if domain_name_lower:match("ubuntu") then
    return "wsl-ubuntu"
  end

  if domain_name_lower:match("kali") then
    return "wsl-kali"
  end

  return "wsl-other"
end

function M.get_shell_icon(wezterm, shell_kind)
  if shell_kind == "wsl-fedora" then
    return wezterm.nerdfonts.linux_fedora
  end

  if shell_kind == "wsl-ubuntu" then
    return wezterm.nerdfonts.linux_ubuntu
  end

  if shell_kind == "wsl-kali" then
    return wezterm.nerdfonts.linux_kali_linux
  end

  if shell_kind == "wsl-other" then
    return wezterm.nerdfonts.linux_tux
  end

  return wezterm.nerdfonts.md_powershell
end

function M.format_tab_title(wezterm, tab, max_width)
  local pane_info = tab.active_pane
  local shell_kind = M.get_shell_kind(pane_info)
  local process_name = M.get_display_process_name(pane_info)
  local title = string.format("  %s  %s ", M.get_shell_icon(wezterm, shell_kind), process_name)

  if max_width then
    title = wezterm.truncate_right(title, max_width)
  end

  return {
    { Text = title },
  }
end

return M
