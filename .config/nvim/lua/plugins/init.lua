return {
	-- Multicursor
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			wk.setup({
				delay = 300, -- ms before popup shows
			})

			-- Register group names for cleaner display
			wk.add({
				{ "<leader>g", group = "Go to" },
				{ "<leader>s", group = "Search" },
				{ "<leader>l", group = "LSP" },
				{ "<leader>p", group = "Problems" },
				{ "<leader>m", group = "Marks" },
				{ "<leader>b", group = "Buffers" },
			})
		end,
	},
	{
		"mg979/vim-visual-multi",
		init = function()
			vim.g.VM_leader = "\\" -- disable VM's leader to avoid conflicts
			vim.g.VM_maps = {
				["Find Under"] = "<leader>d",
				["Find Subword Under"] = "<leader>d",
				["Select All"] = "<leader>D",
				["Skip Region"] = "<leader>ds",
			}
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
		config = function()
			local builtin = require("telescope.builtin")
			require("telescope").setup({
				defaults = { file_ignore_patterns = { "node_modules", ".git" } },
			})

			-- Search
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search files" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Search grep" })
			vim.keymap.set("n", "<leader>ss", builtin.current_buffer_fuzzy_find, { desc = "Search in file" })
			vim.keymap.set("n", "<leader>sy", builtin.lsp_document_symbols, { desc = "Search symbols" })
			vim.keymap.set("n", "<leader>sY", builtin.lsp_workspace_symbols, { desc = "Search workspace symbols" })
			vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Search buffers" })
		end,
	},

	-- LSP
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

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local opts = { buffer = ev.buf }
					-- Navigation (go)
					vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>gb", "<C-o>", { desc = "Go back" })
					vim.keymap.set("n", "<leader>gf", "<C-i>", { desc = "Go forward" })

					-- LSP actions
					vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)

					-- Problems
					vim.keymap.set("n", "<leader>pn", vim.diagnostic.goto_next, opts)
					vim.keymap.set("n", "<leader>pp", vim.diagnostic.goto_prev, opts)
				end,
			})
		end,
	},

	-- Treesitter (selection)
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			vim.keymap.set("n", "<leader>v", function()
				require("nvim-treesitter.incremental_selection").init_selection()
			end, { desc = "Start selection" })

			vim.keymap.set("v", "<leader>v", function()
				require("nvim-treesitter.incremental_selection").node_incremental()
			end, { desc = "Expand selection" })

			vim.keymap.set("v", "<leader>V", function()
				require("nvim-treesitter.incremental_selection").node_decremental()
			end, { desc = "Shrink selection" })
		end,
	},

	-- Harpoon (bookmarks)
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()

			vim.keymap.set("n", "<leader>ma", function()
				harpoon:list():add()
			end, { desc = "Add bookmark" })
			vim.keymap.set("n", "<leader>ml", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "List bookmarks" })
			vim.keymap.set("n", "<leader>1", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<leader>2", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<leader>3", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<leader>4", function()
				harpoon:list():select(4)
			end)
		end,
	},

	-- Bufferline
	{
		"akinsho/bufferline.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = { mode = "buffers", diagnostics = "nvim_lsp" },
			})

			vim.keymap.set("n", "<leader>.", ":Explore<CR>", { desc = "File explorer" })
			vim.keymap.set("n", "<leader>be", ":enew<CR>", { desc = "New empty buffer" })
			vim.keymap.set("n", "<leader>bx", ":bd<CR>", { desc = "Close buffer" })
			vim.keymap.set("n", "<leader>bX", ":bd!<CR>", { desc = "Close buffer (force)" })
			vim.keymap.set("n", "<leader>bn", ":BufferLineCycleNext<CR>", { silent = true, desc = "Next buffer" })
			vim.keymap.set("n", "<leader>bp", ":BufferLineCyclePrev<CR>", { silent = true, desc = "Prev buffer" })
			vim.keymap.set("n", "<leader>bx", ":bd<CR>", { silent = true, desc = "Close buffer" })
			vim.keymap.set("n", "<leader>bl", ":Telescope buffers<CR>", { silent = true, desc = "List buffers" })
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip" },
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					go = { "gofumpt", "goimports" },
					lua = { "stylua" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
				},
				-- Format on save (optional)
				-- format_on_save = {
				--   timeout_ms = 500,
				--   lsp_fallback = true,
				-- },
			})

			-- Format file
			vim.keymap.set("n", "<leader>lf", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { desc = "Format file" })

			-- Format selection
			vim.keymap.set("v", "<leader>lf", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { desc = "Format selection" })
		end,
	},
}
