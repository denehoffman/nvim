local wk = require("which-key")

wk.add({
	{ "<leader><leader>", "<cmd>FzfLua grep_project<cr>", desc = "Search project" },
	{ "<esc><esc>", "<cmd>noh<cr>", hidden = true },
	{ "H", "<cmd>bp<cr>", hidden = true },
	{ "L", "<cmd>bn<cr>", hidden = true },
	{
		"<leader>e",
		function(opts)
			Snacks.explorer()
		end,
		desc = "Open Explorer",
		mode = "n",
	},
	{ "j", "gj", hidden = true },
	{ "k", "gk", hidden = true },

	{ "<leader>f", group = "file" },
	{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find File", mode = "n" },
	{ "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Find File", mode = "n" },
	{ "<leader>fn", "<cmd>enew<cr>", desc = "New File", mode = "n" },

	{ "<leader>q", "<cmd>qa<cr>", desc = "Quit All", mode = "n" },
	{ "<leader>w", "<cmd>w<cr>", desc = "Write", mode = "n" },
	{ "<leader>x", "<cmd>bdelete<cr>", desc = "Close Buffer", mode = "n" },
	{ "<leader>c", "<cmd>close<cr>", desc = "Close Window", mode = "n" },

	{ "<leader>l", group = "LSP" },
	{ "<leader>ld", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace Diagnostics", mode = "n" },
	{ "<leader>lw", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics", mode = "n" },
	{ "<leader>lQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List", mode = "n" },
	{
		"<leader>la",
		function()
			vim.lsp.buf.code_action()
		end,
		desc = "Quickfix List",
		mode = "n",
	},
	{ "<leader>lr", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "References", mode = "n" },
	{ "<leader>ls", "<cmd>Trouble symbols toggle focus=false", desc = "Symbols", mode = "n" },
	{
		"<leader>lh",
		require("lsp_lines").toggle,
		desc = "Toggle Inline Diagnostics",
		mode = "n",
	},

	{ "<leader>t", group = "Terminal" },
	{
		"<leader>tt",
		function()
			Snacks.terminal.toggle(cmd, opts)
		end,
		desc = "Toggle Terminal",
		mode = { "n", "t" },
	},

	{ "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Definition", mode = "n" },
	{ "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Declaration", mode = "n" },
	{ "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Implementation", mode = "n" },
	{ "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "Type Definition", mode = "n" },
	{ "gr", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "References", mode = "n" },
	{ "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "Signature", mode = "n" },

	{ "<leader>u", group = "UI" },
	{
		"<leader>ua",
		function()
			Snacks.toggle.animate()
		end,
		desc = "Toggle Animations",
		mode = "n",
	},
	{
		"<leader>ud",
		function()
			Snacks.toggle.dim()
		end,
		desc = "Toggle Dimming",
		mode = "n",
	},
	{
		"<leader>uh",
		function()
			Snacks.toggle.inlay_hints(opts)
		end,
		desc = "Toggle Inlay Hints",
		mode = "n",
	},
	{
		"<leader>ul",
		function()
			Snacks.toggle.line_number(opts)
		end,
		desc = "Toggle Line Numbers",
		mode = "n",
	},
	{
		"<leader>uz",
		function()
			Snacks.toggle.zen()
		end,
		desc = "Toggle Zen Mode",
		mode = "n",
	},
})
