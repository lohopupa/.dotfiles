local M = {}

function M.setup()
	local map = vim.keymap.set

	-- ============ NAVIGATION ============
	map("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
	map("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
	map("n", "<leader>gr", vim.lsp.buf.references, { desc = "Go to references" })
	map("n", "<leader>gb", "<C-o>zz", { desc = "Go back" })
	map("n", "<leader>gf", "<C-i>zz", { desc = "Go forward" })

	-- ============ SEARCH ============
	local telescope = require("telescope.builtin")
	map("n", "<leader>sf", telescope.find_files, { desc = "Search files" })
	map("n", "<leader>sg", telescope.live_grep, { desc = "Search grep" })
	map("n", "<leader>ss", telescope.current_buffer_fuzzy_find, { desc = "Search in file" })
	map("n", "<leader>sy", telescope.lsp_document_symbols, { desc = "Search symbols" })
	map("n", "<leader>sY", telescope.lsp_workspace_symbols, { desc = "Search workspace symbols" })
	map("n", "<leader>sb", telescope.buffers, { desc = "Search buffers" })

	-- ============ LSP ACTIONS ============
	map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code action" })
	map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename" })
	map("n", "<leader>lh", vim.lsp.buf.hover, { desc = "Hover" })
	map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
	map("n", "<leader>lf", function()
		require("conform").format({ async = true, lsp_fallback = true })
	end, { desc = "Format file" })
	map("v", "<leader>lf", function()
		require("conform").format({ async = true, lsp_fallback = true })
	end, { desc = "Format selection" })

	-- ============ PROBLEMS ============
	map("n", "<leader>pn", vim.diagnostic.goto_next, { desc = "Next problem" })
	map("n", "<leader>pp", vim.diagnostic.goto_prev, { desc = "Prev problem" })

	-- ============ SELECTION ============
	map("n", "<leader>v", function()
		require("nvim-treesitter.incremental_selection").init_selection()
	end, { desc = "Start selection" })
	map("v", "<leader>v", function()
		require("nvim-treesitter.incremental_selection").node_incremental()
	end, { desc = "Expand selection" })
	map("v", "<leader>V", function()
		require("nvim-treesitter.incremental_selection").node_decremental()
	end, { desc = "Shrink selection" })

	-- ============ BOOKMARKS ============
	local harpoon = require("harpoon")
	map("n", "<leader>ma", function()
		harpoon:list():add()
	end, { desc = "Add bookmark" })
	map("n", "<leader>ml", function()
		harpoon.ui:toggle_quick_menu(harpoon:list())
	end, { desc = "List bookmarks" })
	map("n", "<leader>1", function()
		harpoon:list():select(1)
	end, { desc = "Bookmark 1" })
	map("n", "<leader>2", function()
		harpoon:list():select(2)
	end, { desc = "Bookmark 2" })
	map("n", "<leader>3", function()
		harpoon:list():select(3)
	end, { desc = "Bookmark 3" })
	map("n", "<leader>4", function()
		harpoon:list():select(4)
	end, { desc = "Bookmark 4" })

	-- ============ BUFFERS ============
	map("n", "<leader>bn", ":BufferLineCycleNext<CR>", { silent = true, desc = "Next buffer" })
	map("n", "<leader>bp", ":BufferLineCyclePrev<CR>", { silent = true, desc = "Prev buffer" })
	map("n", "<leader>bx", ":bd<CR>", { silent = true, desc = "Close buffer" })
	map("n", "<leader>bX", ":bd!<CR>", { silent = true, desc = "Close buffer (force)" })
	map("n", "<leader>be", ":enew<CR>", { silent = true, desc = "New empty buffer" })
	map("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
	map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })

	-- ============ FILE EXPLORER ============
	map("n", "<leader>.", ":Oil<CR>", { desc = "File explorer" })

	-- ============ SEARCH CENTERING ============
	map("n", "n", "nzz")
	map("n", "N", "Nzz")
	map("n", "*", "*zz")
	map("n", "#", "#zz")
	map("n", "<C-d>", "<C-d>zz")
	map("n", "<C-u>", "<C-u>zz")

	-- ============ GIT ============
	local gitsigns = require("gitsigns")

	map("n", "<leader>gg", ":LazyGit<CR>", { desc = "LazyGit" })
	map("n", "<leader>gn", gitsigns.next_hunk, { desc = "Next hunk" })
	map("n", "<leader>gp", gitsigns.prev_hunk, { desc = "Prev hunk" })
	map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk" })
	map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
	map("n", "<leader>gP", gitsigns.preview_hunk, { desc = "Preview hunk" })
	map("n", "<leader>gB", gitsigns.blame_line, { desc = "Blame line" })
	map("n", "<leader>gD", ":DiffviewOpen<CR>", { desc = "Diff view" })
	map("n", "<leader>gq", ":DiffviewClose<CR>", { desc = "Close diff view" })
end

return M
