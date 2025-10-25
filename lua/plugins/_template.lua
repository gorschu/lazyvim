--[[
=====================================================
PLUGIN CONFIGURATION TEMPLATE - Copy and modify this
=====================================================

Safe configuration pattern to avoid clobbering LazyVim defaults:

1. Always use: opts = function(_, opts)
2. For TABLES: vim.tbl_deep_extend("force", opts.key or {}, { ... })
3. For ARRAYS: vim.list_extend(opts.key, { ... })
4. For VALUES: opts.key = value

Quick Reference:
- TABLES (dicts):  { foo = "bar", nested = { ... } }  → tbl_deep_extend
- ARRAYS (lists):  { "item1", "item2" }               → list_extend
- SCALARS:         true, "string", 42                 → direct assign

--]]

-- Delete this when you're done - it's just a template!
if true then
  return {}
end

return {
  {
    "author/plugin-name",
    -- Optional: lazy loading
    -- event = "VeryLazy",
    -- cmd = { "SomeCommand" },
    -- ft = { "lua", "python" },
    -- keys = { { "<leader>x", "<cmd>Something<cr>", desc = "Do something" } },

    -- Safe configuration using function approach
    opts = function(_, opts)
      -- Debug: see what LazyVim configured (remove after debugging)
      -- print("Current opts:", vim.inspect(opts))

      -- Example 1: Merging tables/dicts (key-value pairs)
      opts.some_table = vim.tbl_deep_extend("force", opts.some_table or {}, {
        key1 = "value1",
        nested = {
          enabled = true,
        },
      })

      -- Example 2: Extending top-level arrays/lists (sequential items)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "item1",
        "item2",
      })

      -- Example 3: Two-step pattern - Tables with nested arrays
      -- Step 1: Merge the table parts (NO arrays inside!)
      opts.config = vim.tbl_deep_extend("force", opts.config or {}, {
        enabled = true,
        timeout = 3000,
        -- DON'T include arrays here - handle them separately below!
      })

      -- Step 2: Extend nested arrays separately
      opts.config.nested_array = opts.config.nested_array or {}
      vim.list_extend(opts.config.nested_array, {
        "item1",
        "item2",
      })

      -- Example 4: Setting simple scalar values
      opts.auto_install = true
      opts.timeout = 5000

      -- No need to return opts when modifying in place
    end,

    -- Optional: Additional configuration
    -- config = function()
    --   require("plugin-name").setup({
    --     -- Custom setup if needed
    --   })
    -- end,
  },

  -- Example: Importing LazyVim extras
  -- { import = "lazyvim.plugins.extras.lang.go" },

  -- Example: Disabling a plugin
  -- { "some/plugin", enabled = false },
}
