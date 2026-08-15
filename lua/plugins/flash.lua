return {
  {
    "folke/flash.nvim",
    opts = function(_, opts)
      opts.modes = opts.modes or {}
      opts.modes.search = opts.modes.search or {}
      opts.modes.search.enabled = true
    end,
  },
}
