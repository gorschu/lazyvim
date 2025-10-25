# LazyVim Plugin Configuration Guide

## Quick Copy-Paste Template

```lua
-- Copy this to the top of any new plugin file
return {
  {
    "author/plugin-name",
    opts = function(_, opts)
      -- TABLES: use vim.tbl_deep_extend("force", ...)
      -- ARRAYS: use vim.list_extend(...)
      -- VALUES: use direct assignment

      -- Your config here
    end,
  },
}
```

## The Three Rules

### 1️⃣ Tables/Dicts (key-value pairs)
**Pattern:** `{ foo = "bar", nested = { ... } }`

```lua
opts.config = vim.tbl_deep_extend("force", opts.config or {}, {
  enabled = true,
  integrations = {
    markdown = true,
  },
})
```

⚠️ **WARNING:** If the table contains nested arrays, handle them separately (see pattern below)!

### 2️⃣ Arrays/Lists (sequential items)
**Pattern:** `{ "item1", "item2", "item3" }`

```lua
opts.ensure_installed = opts.ensure_installed or {}
vim.list_extend(opts.ensure_installed, {
  "go",
  "python",
})
```

⚠️ **WARNING:** Never use `opts.ensure_installed = { "go" }` - this replaces the entire array!

### 3️⃣ Scalar Values (single values)
**Pattern:** `true`, `"string"`, `42`

```lua
opts.auto_install = true
opts.timeout = 5000
opts.colorscheme = "catppuccin"
```

## The Two-Step Pattern: Tables + Arrays

**When a table contains arrays, handle them separately:**

```lua
opts = function(_, opts)
  -- Step 1: Merge the table parts (non-array values only)
  opts.config = vim.tbl_deep_extend("force", opts.config or {}, {
    enabled = true,
    timeout = 3000,
    -- DON'T include arrays here!
  })

  -- Step 2: Extend nested arrays separately
  opts.config.parsers = opts.config.parsers or {}
  vim.list_extend(opts.config.parsers, {
    "go",
    "python",
  })
end
```

### ❌ Common Mistake
```lua
-- This REPLACES the nested array instead of extending it!
opts.config = vim.tbl_deep_extend("force", opts.config or {}, {
  enabled = true,
  parsers = { "go" },  -- ❌ Lost all default parsers!
})
```

### ✅ Correct Approach
```lua
-- First merge tables, then extend arrays
opts.config = vim.tbl_deep_extend("force", opts.config or {}, {
  enabled = true,
  -- No arrays here
})

opts.config.parsers = opts.config.parsers or {}
vim.list_extend(opts.config.parsers, { "go" })  -- ✅ Extends defaults
```

### Why Keep Them Separate?
- **Clarity:** Clear separation of concerns (tables vs arrays)
- **Safety:** No side effects inside `tbl_deep_extend`
- **Debuggability:** Can print/inspect between steps
- **Maintainability:** Easy to understand what's being modified

## Common Examples

### Treesitter (extending parsers)
```lua
{
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "go",
      "python",
      "bash",
    })
  end,
}
```

### Mason (extending tools)
```lua
{
  "williamboman/mason.nvim",
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(opts.ensure_installed, {
      "stylua",
      "shellcheck",
      "shfmt",
    })
  end,
}
```

### LSP (adding servers)
```lua
{
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
      gopls = {
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
            },
          },
        },
      },
    })
  end,
}
```

### Conform (adding formatters)
```lua
{
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters_by_ft.sh = { "shfmt" }
    opts.formatters_by_ft.python = { "isort", "black" }
  end,
}
```

## Debugging Tips

### See what LazyVim configured
```lua
opts = function(_, opts)
  -- Print current configuration
  print("Current opts:", vim.inspect(opts))

  -- Your modifications here
end
```

### Check if a key exists before modifying
```lua
opts = function(_, opts)
  if opts.some_key then
    -- Key exists, safe to modify
    opts.some_key.enabled = true
  else
    -- Key doesn't exist, create it
    opts.some_key = { enabled = true }
  end
end
```

## LazyVim Extras

Instead of manual configuration, check if LazyVim has an "extra" for your language/tool:

```lua
-- In nvim, run:
:LazyExtras

-- Or import directly:
{ import = "lazyvim.plugins.extras.lang.go" }
{ import = "lazyvim.plugins.extras.lang.python" }
{ import = "lazyvim.plugins.extras.lang.json" }
```

See all extras: `find ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras -name "*.lua"`

## When in Doubt

**Always use the function approach with `vim.tbl_deep_extend` or `vim.list_extend`.**

It's better to be verbose and safe than concise and broken!
