-- Snacks.nvim configuration
-- Snacks is a collection of QoL plugins built into LazyVim
-- See: https://github.com/folke/snacks.nvim

return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      -- Enable image rendering in terminal
      opts.image = vim.tbl_deep_extend("force", opts.image or {}, {
        enabled = true,
        backend = "auto",
        integrations = {
          markdown = true,
          neorg = false,
        },
      })
      opts.statuscolumn = vim.tbl_deep_extend("force", opts.statuscolumn or {}, {
        enabled = true,
      })
    end,
  },
}
