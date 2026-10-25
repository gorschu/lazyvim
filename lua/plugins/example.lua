-- Reference examples only. This file deliberately contributes no active specs.
-- See PLUGIN_CONFIG_GUIDE.md and _template.lua before copying an example.
if true then
  return {}
end

return {
  -- A dictionary override merges with the inherited Flash settings.
  {
    "folke/flash.nvim",
    optional = true,
    opts = {
      modes = {
        search = { enabled = true },
      },
    },
  },

  -- These plugins declare ensure_installed in opts_extend.
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "tsx" } },
  },
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "shellcheck" } },
  },

  -- Scalar changes can also mutate inherited options in place.
  {
    "LazyVim/LazyVim",
    optional = true,
    opts = function(_, opts)
      opts.colorscheme = "tokyonight"
    end,
  },

  -- Use :LazyExtras for language integrations such as TypeScript and Python.
  -- Avoid copying an old LSP/completion stack from an unrelated starter config.
}
