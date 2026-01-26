return {
	{
		"lervag/vimtex",
		lazy = false,
		init = function()
			local sysname = vim.loop.os_uname().sysname
			vim.g.vimtex_compiler_method = "tectonic"
			if sysname == "Darwin" then
				vim.g.vimtex_view_method = "skim"
			else
				vim.g.vimtex_view_method = "zathura"
			end
		end,
	},
}
