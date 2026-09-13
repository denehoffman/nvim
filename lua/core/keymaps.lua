local wk = require("which-key")

wk.add({
	{
		"<leader><leader>",
		function()
			Snacks.picker.grep()
		end,
		desc = "search project",
	},
	{
		"<leader><space>",
		function()
			Snacks.dashboard.open()
		end,
		desc = "show dashboard",
	},
	{ "<esc><esc>", "<cmd>noh<cr>", hidden = true },
	{ "H", "<cmd>BufferPrevious<cr>", hidden = true },
	{ "L", "<cmd>BufferNext<cr>", hidden = true },
	{
		"<leader>e",
		function(opts)
			Snacks.explorer()
		end,
		desc = "open explorer",
		mode = "n",
	},
	{ "j", "gj", hidden = true },
	{ "k", "gk", hidden = true },
	{ "<C-h>", "<C-w>h", desc = "move left" },
	{ "<C-j>", "<C-w>j", desc = "move down" },
	{ "<C-k>", "<C-w>k", desc = "move up" },
	{ "<C-l>", "<C-w>l", desc = "move right" },

	{ "<leader>s", group = "split" },
	{ "<leader>sh", "<cmd>leftabove vsplit<cr>", desc = "split to left" },
	{ "<leader>sj", "<cmd>belowright split<cr>", desc = "split below" },
	{ "<leader>sk", "<cmd>aboveleft split<cr>", desc = "split above" },
	{ "<leader>sl", "<cmd>rightbelow vsplit<cr>", desc = "split to right" },

	{ "<leader>f", group = "file" },
	{
		"<leader>ff",
		function()
			Snacks.picker.files()
		end,
		desc = "find file",
		mode = "n",
	},
	{
		"<leader>fb",
		function()
			Snacks.picker.buffers()
		end,
		desc = "find buffer",
		mode = "n",
	},
	{
		"<leader>fp",
		function()
			Snacks.picker.projects()
		end,
		desc = "find project",
		mode = "n",
	},
	{
		"<leader>fo",
		function()
			Snacks.picker.recent()
		end,
		desc = "recent files",
		mode = "n",
	},
	{ "<leader>fn", "<cmd>enew<cr>", desc = "new file", mode = "n" },
	{
		"<leader>fr",
		function()
			require("grug-far").open({ transient = true })
		end,
		desc = "find/replace",
		mode = "n",
	},

	{ "<leader>q", "<cmd>qa<cr>", desc = "quit all", mode = "n" },
	{ "<leader>w", "<cmd>w<cr>", desc = "write", mode = "n" },
	{ "<leader>x", "<cmd>BufferClose<cr>", desc = "close buffer", mode = "n" },
	{ "<leader>X", "<cmd>BufferRestore<cr>", desc = "restore buffer", mode = "n" },
	{ "<leader>c", "<cmd>close<cr>", desc = "close window", mode = "n" },

	{ "<leader>l", group = "lsp" },
	{ "<leader>a", group = "AI" },
	{ "<leader>d", group = "debug" },
	{ "<leader>g", group = "git" },
	{ "<leader>ld", "<cmd>Trouble diagnostics toggle<cr>", desc = "workspace diagnostics", mode = "n" },
	{ "<leader>lw", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "buffer diagnostics", mode = "n" },
	{ "<leader>lQ", "<cmd>Trouble qflist toggle<cr>", desc = "quickfix list", mode = "n" },
	{
		"<leader>la",
		function()
			vim.lsp.buf.code_action()
		end,
		desc = "code actions",
		mode = "n",
	},
	{ "<leader>lr", ":IncRename ", desc = "rename", mode = "n" },
	{ "<leader>lR", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "references", mode = "n" },
	{ "<leader>ls", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "symbols", mode = "n" },
	{
		"<leader>lh",
		require("lsp_lines").toggle,
		desc = "toggle inline diagnostics",
		mode = "n",
	},
	{ "<leader>lt", "<cmd>Trouble todo toggle<cr>", desc = "todos", mode = "n" },
	{ "<leader>lo", "<cmd>AerialToggle<cr>", desc = "code outline", mode = "n" },
	{ "<leader>lc", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "switch C/C++ source/header", mode = "n" },
	{ "<leader>lC", "<cmd>CppHealth<cr>", desc = "check C/C++ project", mode = "n" },

	{ "<leader>t", group = "terminal" },
	{
		"<leader>tt",
		function()
			Snacks.terminal.toggle()
		end,
		desc = "toggle terminal",
		mode = { "n", "t" },
	},

	{ "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "definition", mode = "n" },
	{ "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "declaration", mode = "n" },
	{ "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "implementation", mode = "n" },
	{ "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "type definition", mode = "n" },
	{ "gr", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "references", mode = "n" },
	{ "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "signature", mode = "n" },

	{ "<leader>u", group = "ui" },
	{ "<leader>p", group = "plugins" },
	{ "<leader>pp", "<cmd>Lazy<cr>", desc = "plugin manager", mode = "n" },
	{ "<leader>pu", "<cmd>PluginsUpdate<cr>", desc = "update plugins", mode = "n" },
})

Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle
	.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" })
	:map("<leader>uc")
Snacks.toggle
	.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" })
	:map("<leader>uA")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.animate():map("<leader>ua")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.scroll():map("<leader>uS")
Snacks.toggle.profiler():map("<leader>dpp")
Snacks.toggle.profiler_highlights():map("<leader>dph")
Snacks.toggle.zen():map("<leader>uz")

if vim.lsp.inlay_hint then
	Snacks.toggle.inlay_hints():map("<leader>uh")
end
