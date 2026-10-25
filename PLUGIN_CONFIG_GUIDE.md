# LazyVim plugin configuration guide

Preserve LazyVim's setup, defaults, and integrations when customizing an existing plugin.
Check the installed plugin spec and its documented extension points before editing.

## Choose the smallest supported override

Use an `opts` table for ordinary dictionary and scalar changes. Lazy.nvim merges it with parent specs:

```lua
return {
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        search = { enabled = true },
      },
    },
  },
}
```

Use `opts = function(_, opts)` when the change depends on inherited values or needs list manipulation.
Mutate `opts` in place to preserve inherited configuration:

```lua
opts = function(_, opts)
  opts.some_table = vim.tbl_deep_extend("force", opts.some_table or {}, {
    enabled = true,
  })

  opts.some_list = opts.some_list or {}
  vim.list_extend(opts.some_list, { "additional-item" })
end
```

Returning a new table from an `opts` function replaces the inherited options.
Do that only for an intentional, documented replacement.

## Lists need plugin-specific handling

Ordinary nested lists are replaced, not concatenated, by dictionary merging.
Some LazyVim specs explicitly extend selected lists through `opts_extend`.
Check the installed spec before choosing a pattern.

Treesitter and Mason currently declare `opts_extend = { "ensure_installed" }`, so this preserves their defaults:

```lua
{
  "mason-org/mason.nvim",
  optional = true,
  opts = {
    ensure_installed = { "shellcheck" },
  },
}
```

For lists without that declaration, append explicitly in an `opts` function.
Keep list extension separate from dictionary changes:

```lua
opts = function(_, opts)
  opts.config = vim.tbl_deep_extend("force", opts.config or {}, {
    enabled = true,
  })
  opts.config.items = opts.config.items or {}
  vim.list_extend(opts.config.items, { "additional-item" })
end
```

An existing list may instead need replacement, filtering, or insertion at a specific position.
Document that intention. Appending formatters or completion sources indiscriminately can also change behavior.

## Preserve the setup callback and loading behavior

Prefer `opts` over `config = function() require("plugin").setup(...) end`.
A new `config` function replaces the inherited callback and can bypass LazyVim integrations.
In particular, preserve LazyVim's Conform setup and automatic formatting registration.

Custom `config` is appropriate only when a plugin requires setup that cannot be expressed through `opts`.
For a plugin whose module name cannot be inferred, prefer `main = "module-name"` with `opts`.

For an override that should apply only when another spec enables the plugin, add `optional = true`.
For a plugin this repository intentionally adds, use its normal plugin spec without `optional`.
Preserve existing events, commands, dependencies, keymaps, and conditions unless changing them is the goal.
Use `init` for settings needed before loading, not for eagerly requiring a lazy-loaded plugin.

## Formatting and linting

LazyVim uses Conform for formatting and nvim-lint for linting.
Customize their documented options instead of replacing formatter or linter definitions.

For extra formatter arguments, use `opts.formatters[NAME].prepend_args` or `append_args`.
For extra linter arguments, LazyVim supports `opts.linters[NAME].prepend_args`.
Preserve any existing argument list or argument function when extending an existing override.
Do not replace the built-in `args`, command, parser, conditions, or exit-code handling merely to add flags.

`formatters_by_ft[FILETYPE]` is an ordered chain.
Assigning a new list there intentionally replaces that filetype's existing chain:

```lua
opts = function(_, opts)
  opts.formatters_by_ft = opts.formatters_by_ft or {}
  -- Intentional replacement: use this complete chain for Python.
  opts.formatters_by_ft.python = { "isort", "black" }
end
```

Prefer a language extra when it already provides the desired integration.
Inspect the effective chain and tool availability before changing it.

## Project-sensitive configuration

Options are normally computed when a plugin loads, not once per buffer.
Capturing `vim.fn.getcwd()` in `opts` freezes that value for the session.
Use a documented per-buffer callback or reload mechanism when behavior must follow project changes.
Keep project overrides and the user's working-directory choice intact.

## Extras and current plugin names

Use `:LazyExtras` for maintained language and tool integrations.
The enabled extras are recorded in `lazyvim.json`.
Prefer the extra over copying its entire implementation into this repository.

Use the plugin names from the installed LazyVim spec, such as `mason-org/mason.nvim`.
The lockfile records the versions this repository actually uses; do not update it as part of an unrelated change.

## Verification

After changing Lua, run the repository's formatter check:

```sh
stylua --check .
```

For the configured repository hooks, run:

```sh
prek run --all-files
```

For changes to inherited options, inspect the effective options after lazy.nvim merges the specs.
Check the behavior that changed, including existing conditions and project overrides.
Do not equate a successful syntax check with a successful integration test.
Use `:ConformInfo`, `:LspInfo`, and `:checkhealth` when relevant to the changed integration.

## References

- [LazyVim plugin customization](https://www.lazyvim.org/configuration/plugins)
- [Lazy.nvim plugin specification](https://lazy.folke.io/spec)
- [LazyVim formatting](https://www.lazyvim.org/plugins/formatting)
- [LazyVim linting](https://www.lazyvim.org/plugins/linting)
- [LazyVim Treesitter spec](https://www.lazyvim.org/plugins/treesitter)
