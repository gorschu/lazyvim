-- blink.cmp configuration

return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, { preset = "super-tab" })

      -- Don't auto-insert completions while navigating the menu; only apply on confirm
      opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
      })

      -- Ensure nested structure exists (without arrays)
      opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
        providers = {
          snippets = {
            opts = {},
          },
        },
      })

      local provider = opts.sources.providers.snippets
      local source_opts = vim.deepcopy(provider.opts)
      local paths = source_opts.search_paths or { vim.fn.stdpath("config") .. "/snippets" }
      local projects = {}
      provider.override = provider.override or {}
      local get_completions = provider.override.get_completions
      local reload = provider.override.reload

      -- Keep Blink's built-in parser and cache each project's .json snippets separately.
      provider.override.get_completions = function(_, context, callback)
        local root = LazyVim.root.get({ buf = context.bufnr })
        if not projects[root] then
          local project_opts = vim.deepcopy(source_opts)
          project_opts.search_paths = vim.list_extend(vim.deepcopy(paths), {
            root .. "/.nvim/snippets",
            root .. "/.vscode",
          })
          projects[root] = require("blink.cmp.sources.snippets").new(project_opts)
        end
        if get_completions then
          return get_completions(projects[root], context, callback)
        end
        return projects[root]:get_completions(context, callback)
      end

      provider.override.reload = function(source)
        projects = {}
        if reload then
          return reload(source)
        end
        return source:reload()
      end
    end,
  },
}
