return {
	{
		"mhartington/formatter.nvim",
		config = function()
			-- Formatter setup
			require("formatter").setup({
				logging = true,
				log_level = vim.log.levels.WARN,
				filetype = {
					lua = { require("formatter.filetypes.lua").stylua },
					python = { require("formatter.filetypes.python").ruff },
					cpp = { require("formatter.filetypes.cpp").clangformat },
					rust = {
						function()
							return {
								exe = "rustfmt",
								args = { "--edition", "2024" },
								stdin = true,
							}
						end,
					},
					["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
				},
			})

			-- Format-on-save toggle variable
			vim.g.format_on_save = true

			-- Autocmd group to allow clearing
			local group = vim.api.nvim_create_augroup("FormatAutogroup", { clear = true })

			vim.api.nvim_create_autocmd("BufWritePost", {
				group = group,
				pattern = "*",
				callback = function()
					if vim.g.format_on_save then
						vim.cmd("FormatWrite")
					end
				end,
			})

			-- Toggle command
			vim.api.nvim_create_user_command("FormatToggle", function()
				vim.g.format_on_save = not vim.g.format_on_save
				print("Format on save: " .. (vim.g.format_on_save and "enabled" or "disabled"))
			end, {})
		end,
	},
}
