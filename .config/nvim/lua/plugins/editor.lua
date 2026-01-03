return {
  {
    "mg979/vim-visual-multi",
    init = function()
      vim.g.VM_leader = "\\"
      vim.g.VM_maps = {
        ["Find Under"] = "<leader>d",
        ["Find Subword Under"] = "<leader>d",
        ["Select All"] = "<leader>D",
        ["Skip Region"] = "<leader>ds",
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon"):setup()
    end,
  },
}
