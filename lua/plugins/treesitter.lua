local languages = {
	"bash",
	"bibtex",
	"c",
	"cpp",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"nix",
	"nu",
	"python",
	"rust",
	"toml",
	"typst",
	"yaml",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter")
			treesitter.setup()
			if not vim.env.DENE_NIX_PLUGIN_ROOT then
				treesitter.install(languages)
			end
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					pcall(vim.treesitter.start, args.buf)
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
				move = { set_jumps = true },
			})
			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")
			for _, mode in ipairs({ "x", "o" }) do
				vim.keymap.set(mode, "af", function()
					select.select_textobject("@function.outer", "textobjects", mode)
				end, { desc = "around function" })
				vim.keymap.set(mode, "if", function()
					select.select_textobject("@function.inner", "textobjects", mode)
				end, { desc = "inside function" })
				vim.keymap.set(mode, "ac", function()
					select.select_textobject("@class.outer", "textobjects", mode)
				end, { desc = "around class" })
				vim.keymap.set(mode, "ic", function()
					select.select_textobject("@class.inner", "textobjects", mode)
				end, { desc = "inside class" })
			end
			vim.keymap.set({ "n", "x", "o" }, "]f", function()
				move.goto_next_start("@function.outer", "textobjects")
			end, { desc = "next function" })
			vim.keymap.set({ "n", "x", "o" }, "[f", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end, { desc = "previous function" })
			vim.keymap.set({ "n", "x", "o" }, "]c", function()
				move.goto_next_start("@class.outer", "textobjects")
			end, { desc = "next class" })
			vim.keymap.set({ "n", "x", "o" }, "[c", function()
				move.goto_previous_start("@class.outer", "textobjects")
			end, { desc = "previous class" })
		end,
	},
}
