local requested_colorscheme = vim.env.COLORSCHEME_NAME or "catppuccin"
local requested_flavor = vim.env.COLORSCHEME_FLAVOR

local valid_flavors = {
  catppuccin = {
    latte = true,
    frappe = true,
    macchiato = true,
    mocha = true,
  },
  tokyonight = {
    storm = true,
    night = true,
    moon = true,
    day = true,
  },
}

local default_flavors = {
  catppuccin = "mocha",
  tokyonight = "storm",
}

local colorscheme = valid_flavors[requested_colorscheme] and requested_colorscheme or "catppuccin"
local flavor = valid_flavors[colorscheme][requested_flavor] and requested_flavor or default_flavors[colorscheme]

return {
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.colorscheme = colorscheme
    end,
  },
  {
    "catppuccin/nvim",
    lazy = true,
    opts = function(_, opts)
      opts.flavour = flavor
      opts.term_colors = true
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = function(_, opts)
      opts.style = flavor
      opts.light_style = "day"
      opts.terminal_colors = true
      opts.lualine_bold = true
      opts.styles = vim.tbl_deep_extend("force", opts.styles or {}, {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "dark",
        floats = "dark",
      })
    end,
  },
}
