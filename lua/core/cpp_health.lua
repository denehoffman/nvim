local M = {}

local markers = { "compile_commands.json", "build/compile_commands.json", "compile_flags.txt" }

local function root_for(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "clangd" })
	if clients[1] and clients[1].root_dir then
		return clients[1].root_dir
	end
	local file = vim.api.nvim_buf_get_name(bufnr)
	local marker = vim.fs.find({ ".clangd", ".git", "CMakeLists.txt" }, { path = file, upward = true })[1]
	return marker and vim.fs.dirname(marker) or vim.fs.dirname(file)
end

function M.inspect(bufnr, quiet)
	bufnr = bufnr or 0
	local root = root_for(bufnr)
	local database
	for _, marker in ipairs(markers) do
		local candidate = root .. "/" .. marker
		if vim.uv.fs_stat(candidate) then
			database = candidate
			break
		end
	end

	if not database then
		vim.notify(
			("clangd: no compilation database under %s. Generate build/compile_commands.json or add compile_flags.txt."):format(
				root
			),
			vim.log.levels.WARN
		)
		return false
	end

	if database:match("compile_commands%.json$") then
		local ok, contents = pcall(vim.fn.readfile, database, "", 200)
		if ok then
			local joined = table.concat(contents, "\n")
			if joined:find("/nix/store/.-%-wrapper%-") and not vim.env.NIX_CFLAGS_COMPILE then
				vim.notify(
					"clangd: this database uses a Nix compiler wrapper, but Neovim was started outside the project environment. Enter the project directory, let direnv load, then restart Neovim.",
					vim.log.levels.WARN
				)
				return false
			end
			local directory = joined:match('"directory"%s*:%s*"([^"]+)"')
			if directory and not vim.uv.fs_stat(directory) then
				vim.notify(
					("clangd: %s contains a missing build directory:\n%s\nRegenerate it inside this project's environment."):format(
						database,
						directory
					),
					vim.log.levels.WARN
				)
				return false
			end
		end
	end

	if not quiet then
		vim.notify(("clangd compilation database: %s"):format(database), vim.log.levels.INFO)
	end
	return true
end

return M
