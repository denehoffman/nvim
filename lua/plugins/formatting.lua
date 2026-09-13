return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>lf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				desc = "format buffer",
				mode = { "n", "v" },
			},
		},
		opts = {
			formatters_by_ft = {
				bib = { "bibtex_tidy" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				json = { "prettier", stop_after_first = true },
				lua = { "stylua" },
				nix = { "nixfmt" },
				python = { "ruff_format" },
				rust = { "rustfmt", lsp_format = "fallback" },
			},
			format_on_save = function(bufnr)
				if vim.b[bufnr].disable_autoformat or vim.g.disable_autoformat then
					return nil
				end
				return { timeout_ms = 1000, lsp_format = "fallback" }
			end,
			formatters = {
				bibtex_tidy = { prepend_args = { "--v2", "--quiet", "--sort-fields", "--blank-lines" } },
			},
		},
		init = function()
			vim.api.nvim_create_user_command("FormatToggle", function(args)
				if args.bang then
					vim.b.disable_autoformat = not vim.b.disable_autoformat
					vim.notify("Buffer format on save: " .. (vim.b.disable_autoformat and "off" or "on"))
				else
					vim.g.disable_autoformat = not vim.g.disable_autoformat
					vim.notify("Format on save: " .. (vim.g.disable_autoformat and "off" or "on"))
				end
			end, { bang = true, desc = "Toggle format on save; ! limits it to this buffer" })
		end,
	},
}
