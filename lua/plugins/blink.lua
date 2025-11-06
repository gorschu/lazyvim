-- blink.cmp configuration

return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- Ensure nested structure exists (without arrays)
      opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
        providers = {
          snippets = {
            opts = {},
          },
        },
      })

      -- Add project-local snippet paths (we need to support .vscode locations)
      -- Extend snippet search paths array
      opts.sources.providers.snippets.opts.search_paths = opts.sources.providers.snippets.opts.search_paths or {}
      vim.list_extend(opts.sources.providers.snippets.opts.search_paths, {
        vim.fn.stdpath("config") .. "/snippets", -- Global: ~/.config/nvim/snippets
        vim.fn.getcwd() .. "/.nvim/snippets", -- Project
        vim.fn.getcwd() .. "/.vscode", -- Project
      })
    end,
  },
}
