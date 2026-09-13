return {
	{ "echasnovski/mini.ai", version = false, opts = { n_lines = 500 } },
	{ "echasnovski/mini.surround", version = false, opts = {} },
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "flash jump",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "flash treesitter",
			},
		},
	},
	{
		"chrisgrieser/nvim-origami",
		event = "VeryLazy",
		opts = { autoFold = { enabled = false } },
	},
	{ "stevearc/aerial.nvim", cmd = { "AerialToggle", "AerialNavToggle" }, opts = { show_guides = true } },
}
