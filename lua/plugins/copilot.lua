return {
  {
    "zbirenbaum/copilot.lua",
    optional = true,
    opts = function(_, opts)
      opts.filetypes = vim.tbl_deep_extend("force", opts.filetypes or {}, {
        beancount = false,
      })
    end,
  },
}
