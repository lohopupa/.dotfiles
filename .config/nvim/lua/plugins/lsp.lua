return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({ ensure_installed = { "gopls" } })

      vim.lsp.config("gopls", {
        cmd = { "gopls" },
        root_markers = { "go.work", "go.mod", ".git" },
        settings = {
          gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })
      vim.lsp.enable("gopls")
    end,
  },
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          go = { "gofumpt", "goimports" },
          lua = { "stylua" },
        },
      })
    end,
  },
}
