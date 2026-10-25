local function shared_config_args()
  local config_home = vim.env.XDG_CONFIG_HOME or vim.fn.expand("~/.config")
  local path = vim.fs.joinpath(config_home, "markdownlint", "config.yaml")
  return vim.fn.filereadable(path) == 1 and { "--config", path } or {}
end

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters = vim.tbl_deep_extend("force", opts.linters or {}, {
        ["markdownlint-cli2"] = {},
      })

      -- LazyVim merges this override with nvim-lint's built-in definition.
      local linter = opts.linters["markdownlint-cli2"]
      linter.prepend_args = linter.prepend_args or {}
      vim.list_extend(linter.prepend_args, shared_config_args())
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
        ["markdownlint-cli2"] = {},
      })

      local formatter = opts.formatters["markdownlint-cli2"]
      local previous_args = formatter.prepend_args
      formatter.prepend_args = function(self, ctx)
        local args = type(previous_args) == "function" and previous_args(self, ctx) or previous_args
        return vim.list_extend(vim.deepcopy(args or {}), shared_config_args())
      end
    end,
  },
}
