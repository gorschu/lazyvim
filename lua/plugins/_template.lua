--[[
Plugin configuration template. See PLUGIN_CONFIG_GUIDE.md before copying.

1. Ordinary opts dictionaries merge automatically with inherited options.
2. Use opts = function(_, opts) to inspect inherited values or manipulate lists.
   Mutate opts in place; returning a new table replaces inherited options.
3. Check opts_extend before changing lists. Treesitter and Mason extend their
   ensure_installed lists automatically. Other lists may require vim.list_extend.
4. Keep dictionary merging and manual list extension separate.
5. Preserve LazyVim's config callback, conditions, arguments, and loading behavior.
   Prefer documented extension points such as prepend_args over replacing setup.
6. Add optional = true only when another spec should control plugin inclusion.
]]

-- Keep this template inactive. Remove this guard only from a customized copy.
if true then
  return {}
end

return {
  -- New plugin: ordinary dictionaries and scalars need no manual merging.
  {
    "author/plugin-name",
    opts = {
      enabled = true,
      nested = { setting = "value" },
    },
  },

  -- Existing plugin: inspect and mutate inherited values when needed.
  {
    "author/another-plugin",
    optional = true,
    opts = function(_, opts)
      opts.some_table = vim.tbl_deep_extend("force", opts.some_table or {}, {
        enabled = true,
      })

      -- For a list without opts_extend, extend it separately.
      opts.some_list = opts.some_list or {}
      vim.list_extend(opts.some_list, { "additional-item" })

      opts.some_value = true
      -- No return: retain the inherited options.
    end,
  },

  -- Mason's native opts_extend preserves its existing installation list.
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = {
      ensure_installed = { "shellcheck" },
    },
  },

  -- Keep language integrations in LazyExtras rather than copying their defaults.
  -- Enable an extra with :LazyExtras; enabled extras are saved in lazyvim.json.
}
