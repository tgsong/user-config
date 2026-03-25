-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.initial_cols = 180
config.initial_rows = 50
config.color_scheme = 'Default Dark (base16)'
-- config.color_scheme = 'Dark+'
-- config.color_scheme = 'Dracula'
-- config.color_scheme = 'OneHalfDark'
config.font = wezterm.font 'CaskaydiaCove Nerd Font'
config.window_frame = { font = wezterm.font { family = 'CaskaydiaCove Nerd Font' } }

local act = wezterm.action
local mod_key = string.find(wezterm.target_triple, 'apple') and 'CMD' or 'CTRL'
config.keys = {
  { key = '_', mods = 'ALT|SHIFT', action = act.SplitVertical },
  { key = '+', mods = 'ALT|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'l', mods = 'ALT', action = act.ShowLauncher},
  { key = 'w', mods = mod_key, action = act.CloseCurrentPane { confirm = false }},
  { key = '{', mods = mod_key .. '|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = '}', mods = mod_key .. '|SHIFT', action = act.ActivateTabRelative(1) },
}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.window_decorations = "RESIZE"
  config.mux_enable_ssh_agent = false
  config.default_prog = { 'nu' }
  config.default_cwd = 'C:/Users/tgsong/workspace'
  config.launch_menu = {
    { label = 'Debian', domain = { DomainName = 'WSL:Debian' } },
    { label = 'Nushell', domain = 'DefaultDomain', args = { 'nu' } },
    { label = 'PowerShell', domain = 'DefaultDomain', args = { 'pwsh' } },
    { label = 'PowerShell 5', domain = 'DefaultDomain', args = { 'powershell' } },
  }
end

config.mouse_bindings = {
  -- Disable the default left-click behavior (which opens URLs)
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.DisableDefaultAssignment,
  },
  -- Enable Ctrl+Click to open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
  -- Prevent Ctrl+Click from being interpreted by other programs
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = wezterm.action.Nop,
  },
}

-- and finally, return the configuration to wezterm
return config
