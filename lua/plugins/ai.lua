return {
	{
		"Exafunction/windsurf.nvim",
		event = "InsertEnter",
		cmd = "Codeium",
		dependencies = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" },
		opts = {
			enable_cmp_source = true,
			virtual_text = { enabled = false },
		},
		config = function(_, opts)
			require("codeium").setup(opts)
		end,
		keys = {
			{
				"<leader>at",
				function()
					require("codeium").toggle()
				end,
				desc = "toggle Windsurf completions",
			},
		},
	},
}
