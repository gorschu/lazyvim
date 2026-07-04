return {
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "folke/snacks.nvim",
      "esmuellert/codediff.nvim",
    },
    keys = {
      {
        "<leader>gn",
        function()
          require("neogit").open({ cwd = LazyVim.root.git() })
        end,
        desc = "Neogit (Root Dir)",
      },
      {
        "<leader>gN",
        function()
          require("neogit").open({ cwd = vim.uv.cwd() })
        end,
        desc = "Neogit (cwd)",
      },
    },
    opts = {
      integrations = {
        snacks = true,
        codediff = true,
      },
      diff_viewer = "codediff",
    },
  },
}
