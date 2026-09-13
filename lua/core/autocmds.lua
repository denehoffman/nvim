local function augroup(name)
	return vim.api.nvim_create_augroup("dene_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = augroup("uv_python_shebang"),
	callback = function(args)
		local first_line = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1] or ""
		if first_line:match("^#!/usr/bin/env%s+%-S%s+uv%s+run") then
			vim.bo[args.buf].filetype = "python"
		end
	end,
})
