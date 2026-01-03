return {
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = { mode = "buffers", diagnostics = "nvim_lsp" },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({ delay = 300 })
      wk.add({
        { "<leader>g", group = "Git / Go to" },
        { "<leader>s", group = "Search" },
        { "<leader>l", group = "LSP" },
        { "<leader>p", group = "Problems" },
        { "<leader>m", group = "Marks" },
        { "<leader>b", group = "Buffers" },
      })
    end,
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup()
    end,
  },
}
