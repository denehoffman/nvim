return {
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
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({})
		end,
	},
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim",
			"nvim-tree/nvim-web-devicons",
		},
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
		"rcarriga/nvim-notify",
		config = function()
			require("notify").setup({
				timeout = 1000,
				stages = "static",
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
			animate = {},
			dim = {},
			explorer = {},
			indent = {},
			input = {},
			picker = {
				sources = {
					explorer = {
						replace_netrw = true,
					},
				},
			},
			scroll = {},
			terminal = {},
			toggle = {},
			zen = {},
		},
	},
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup()
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		"goolord/alpha-nvim",
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")
			dashboard.section.header.val = {
				"      _                           ",
				"      \\`*-.                       ",
				"       )  _`-.                    ",
				"      .  : `. .                   ",
				"      : _   '  \\                  ",
				"      ; *` _.   `*-._             ",
				"      `-.-'          `-.          ",
				"        ;       `       `.        ",
				"        :.       .        \\       ",
				"        . \\  .   :   .-'   .      ",
				"        '  `+.;  ;  '      :      ",
				"        :  '  |    ;       ;-.    ",
				"        ; '   : :`-:     _.`* ;   ",
				"[bug] .*' /  .*' ; .*`- +'  `*'   ",
				"      `*-*   `*-*  `*-*'          ",
			}
			dashboard.section.buttons.val = {
				dashboard.button("n", " 📝 New File", "<cmd>enew<cr>"),
				dashboard.button("f", " 🔍 Find File", "<cmd>FzfLua files<cr>"),
				dashboard.button("r", " 🕘 Recent Files", "<cmd>FzfLua oldfiles<cr>"),
			}
			alpha.setup(dashboard.opts)
		end,
	},
}
