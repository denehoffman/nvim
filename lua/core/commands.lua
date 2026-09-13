vim.api.nvim_create_user_command("PluginsUpdate", function()
	require("lazy").update({ show = true })
end, { desc = "Update plugins and the Lazy lock file" })

vim.api.nvim_create_user_command("PluginsSync", function()
	require("lazy").sync({ show = true })
end, { desc = "Install, clean, and update plugins to match the configuration" })

vim.api.nvim_create_user_command("ConfigHealth", function()
	vim.cmd("checkhealth vim.lsp vim.treesitter lazy")
end, { desc = "Check the health of the core Neovim configuration" })

vim.api.nvim_create_user_command("ConfigReload", function()
	for name, _ in pairs(package.loaded) do
		if name:match("^core") then
			package.loaded[name] = nil
		end
	end
	dofile(vim.env.MYVIMRC)
end, { desc = "Reload core Lua modules; plugin spec changes may require a restart" })

vim.api.nvim_create_user_command("CppHealth", function()
	require("core.cpp_health").inspect(0, false)
end, { desc = "Check clangd and the current project's compilation database" })
