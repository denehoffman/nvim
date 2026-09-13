return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end
				map("n", "]h", function()
					gs.nav_hunk("next")
				end, "next git hunk")
				map("n", "[h", function()
					gs.nav_hunk("prev")
				end, "previous git hunk")
				map("n", "<leader>gp", gs.preview_hunk, "preview hunk")
				map({ "n", "v" }, "<leader>gs", gs.stage_hunk, "stage hunk")
				map({ "n", "v" }, "<leader>gr", gs.reset_hunk, "reset hunk")
				map("n", "<leader>gb", gs.toggle_current_line_blame, "toggle line blame")
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "git hunk")
			end,
		},
	},
	{ "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" } },
}
