-- Luacheck configuration for Neovim config
-- See: https://luacheck.readthedocs.io/

-- Global objects defined by Neovim
globals = {
  "vim",
}

-- Allow vim global to be redefined
read_globals = {
  "vim",
}

-- Ignore warnings about line length
max_line_length = false

-- Ignore certain warnings
ignore = {
  "212", -- Unused argument (common in Lua callbacks)
  "631", -- Line is too long
}
