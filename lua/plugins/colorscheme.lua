local colorscheme = vim.env.COLORSCHEME_NAME or "catppuccin"
local flavor = vim.env.COLORSCHEME_FLAVOR or "macchiato"

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
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = function(_, opts)
      opts.style = flavor
    end,
  },
}
