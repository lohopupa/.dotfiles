-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Leader key
vim.g.mapleader = " "

-- Load plugins
require("lazy").setup("plugins")
-- Execute line/selection in bash and paste output
local function execute_in_bash()
  local lines
  local mode = vim.fn.mode()

  if mode == "v" or mode == "V" then
    -- Get visual selection
    vim.cmd('noau normal! "vy')
    lines = vim.fn.getreg("v")
  else
    -- Get current line
    lines = vim.api.nvim_get_current_line()
  end

  -- Execute and capture stdout + stderr
  local output = vim.fn.system("bash -c " .. vim.fn.shellescape(lines) .. " 2>&1")

  -- Remove trailing newline
  output = output:gsub("\n$", "")

  -- Paste below current line/selection
  local current_line = vim.fn.line(".")
  local output_lines = vim.split(output, "\n")
  vim.api.nvim_buf_set_lines(0, current_line, current_line, false, output_lines)
end

vim.keymap.set("n", "<leader>x", execute_in_bash, { desc = "Execute line in bash" })
vim.keymap.set("v", "<leader>x", execute_in_bash, { desc = "Execute selection in bash" })
