local function lsp_journal_path()
  -- global has top priority (e.g. in ftplugin)
  local override = vim.g.beancount_lsp_journal
  if type(override) == "string" and override ~= "" then
    return vim.fn.expand(override)
  end

  -- fallback chain: env
  -- we usually set BEANCOUNT_JOURNAL from mise
  local env = vim.env.BEANCOUNT_JOURNAL
  if type(env) == "string" and env ~= "" then
    return vim.fn.expand(env)
  end

  -- fallback chain: config fir -> beancount/...
  -- this should actually always fail, but at least we can pass something
  return vim.fn.stdpath("config") .. "/beancount/main.bean"
end

return {
  {
    "LazyVim/LazyVim",
    -- common convention for lazyvim tweaks
    optional = true,
    -- this init runs alongside LazyVim's own init
    -- this just appends filetype rules, safe
    init = function()
      vim.filetype.add({
        extension = {
          bean = "beancount",
          beancount = "beancount",
        },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "beancount") then
        table.insert(opts.ensure_installed, "beancount")
      end
    end,
  },

  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "beancount-language-server") then
        table.insert(opts.ensure_installed, "beancount-language-server")
      end
    end,
  },

  {
    "neovim/nvim-lspconfig",
    ft = { "beancount" },
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.beancount = vim.tbl_deep_extend("force", {
        init_options = {
          journal_file = lsp_journal_path(),
        },
      }, opts.servers.beancount or {})
    end,
  },
}
