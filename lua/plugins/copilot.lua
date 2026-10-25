return {
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = function(_, opts)
      -- Only adjust copilot when an enabled extra configures it.
      local server = opts.servers and opts.servers.copilot
      if not server then
        return
      end
      -- LazyVim also accepts `copilot = true`; normalize it to a table.
      if server == true then
        server = {}
        opts.servers.copilot = server
      end
      local defaults = vim.lsp.config.copilot or {}
      local root_dir = server.root_dir or defaults.root_dir
      local root_markers = server.root_markers or defaults.root_markers

      -- Skip activation entirely for financial journals, including Sidekick's LSP use.
      server.root_dir = function(bufnr, on_dir)
        if vim.bo[bufnr].filetype == "beancount" then
          return
        end
        if type(root_dir) == "function" then
          return root_dir(bufnr, on_dir)
        end
        on_dir(root_dir or (root_markers and vim.fs.root(bufnr, root_markers)))
      end
    end,
  },
}
