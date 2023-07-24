-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

config.initial_cols = 180
config.initial_rows = 50
config.color_scheme = 'Dracula'
config.font = wezterm.font 'CaskaydiaCove Nerd Font'
config.window_frame = { font = wezterm.font { family = 'CaskaydiaCove Nerd Font' } }
config.keys = {
  { key = '_', mods = 'ALT|SHIFT', action = wezterm.action.SplitVertical },
  { key = '+', mods = 'ALT|SHIFT', action = wezterm.action.SplitHorizontal },
}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_prog = { 'pwsh' }
end

-- and finally, return the configuration to wezterm
return config
