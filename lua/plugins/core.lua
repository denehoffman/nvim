return {
	{
		"VonHeikemen/lsp-zero.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-buffer",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			"honza/vim-snippets",
		},
		config = function()
			local lsp_zero = require("lsp-zero")
			local lspconfig_defaults = require("lspconfig").util.default_config
			lspconfig_defaults.capabilities = vim.tbl_deep_extend(
				"force",
				lspconfig_defaults.capabilities,
				require("cmp_nvim_lsp").default_capabilities()
			)

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ruff",
					"pyrefly", -- TODO: Change to ty when possible
					"rust_analyzer",
					"lua_ls",
				},
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({})
					end,
					rust_analyzer = function()
						require("lspconfig").rust_analyzer.setup({
							settings = {
								["rust-analyzer"] = {
									inlayHints = {
										bindingModeHints = {
											enable = false,
										},
										chainingHints = {
											enable = true,
										},
										closingBraceHints = {
											enable = true,
											minLines = 25,
										},
										closureReturnTypeHints = {
											enable = "never",
										},
										lifetimeElisionHints = {
											enable = "never",
											useParameterNames = false,
										},
										maxLength = 25,
										parameterHints = {
											enable = true,
										},
										reborrowHints = {
											enable = "never",
										},
										renderColons = true,
										typeHints = {
											enable = true,
											hideClosureInitialization = false,
											hideNamedConstructor = false,
										},
									},
								},
							},
						})
					end,
					lua_ls = function()
						local lua_opts = lsp_zero.nvim_lua_ls()
						require("lspconfig").lua_ls.setup(lua_opts)
					end,
				},
			})
			local cmp = require("cmp")
			local cmp_action = require("lsp-zero").cmp_action()
			local cmp_format = require("lsp-zero").cmp_format({ details = true })
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_snipmate").lazy_load()
			require("luasnip").filetype_extend("rust", { "rustdoc" })
			require("luasnip").filetype_extend("python", { "pydoc" })
			cmp.setup({
				preselect = "item",
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				sources = {
					{ name = "codeium" },
					{ name = "luasnip" },
					{ name = "nvim_lsp" },
					{ name = "buffer" },
				},
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp_action.tab_complete(),
					["<S-Tab>"] = cmp_action.vim_snippet_prev(),
				}),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				formatting = cmp_format,
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					hover = {
						enabled = true,
						delay = 200,
						reveal = { "close" },
					},
					indicator = {
						style = "none",
					},
				},
			})
		end,
	},
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			require("lsp_lines").setup()
		end,
	},
	{
		"tpope/vim-sleuth",
		event = { "BufReadPost", "BufNewFile" },
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				integrations = {
					treesitter = true,
					native_lsp = { enabled = true },
					telescope = true,
					which_key = true,
					cmp = true,
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"python",
					"cpp",
					"bash",
					"json",
					"yaml",
					"markdown",
					"rust",
				},
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						node_decremental = "grm",
					},
				},
			})
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				resets = { inc_rename = true },
			})
		end,
	},
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
	{ "akinsho/bufferline.nvim", dependencies = "nvim-tree/nvim-web-devicons" },
	{
		"vladdoster/remember.nvim",
		config = function()
			require("remember")
		end,
	},
	{
		"smjonas/inc-rename.nvim",
		opts = {},
	},
	{
		"MagicDuck/grug-far.nvim",
		config = function()
			require("grug-far").setup({})
		end,
	},
}
