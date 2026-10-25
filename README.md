# nvim

My Neovim config, built on fabulous [LazyVim](https://www.lazyvim.org/).

## Layout

- `lua/plugins/`: plugin specs and overrides
- `lua/config/`: options, keymaps, autocmds
- `lazyvim.json`: enabled extras (manage with `:LazyExtras`)

## Changing plugin config

See [PLUGIN_CONFIG_GUIDE.md](PLUGIN_CONFIG_GUIDE.md) for how to override LazyVim defaults without clobbering them.
[`_template.lua`](lua/plugins/_template.lua) and [`example.lua`](lua/plugins/example.lua) are disabled on purpose and only there to copy from.

Lockfile updates get their own commits.

## Checks

```sh
stylua --check .
prek run --all-files
```

`mise` installs both tools and sets up the git hooks when you enter the directory.
