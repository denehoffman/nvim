return {
	{
		"lervag/vimtex",
		lazy = false,
		init = function()
			local sysname = vim.loop.os_uname().sysname
			vim.g.vimtex_compiler_method = "tectonic"

			vim.api.nvim_create_autocmd("BufWritePost", {
				group = vim.api.nvim_create_augroup("vimtex_compile_on_save", { clear = true }),
				pattern = "*.tex",
				command = "silent! VimtexCompile!",
			})

			if sysname == "Darwin" then
				vim.g.vimtex_view_method = "skim"
			else
				vim.g.vimtex_view_method = "zathura_simple"
			end
		end,
	},
}
