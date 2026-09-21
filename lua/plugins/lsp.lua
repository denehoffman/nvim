local servers = { "clangd", "lua_ls", "nushell", "ruff", "taplo", "ty" }

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp", "folke/lazydev.nvim" },
		config = function()
			vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
			vim.lsp.config("clangd", {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--completion-style=detailed",
					"--header-insertion=iwyu",
					"--query-driver=/nix/store/*-gcc-wrapper-*/bin/g++,/nix/store/*-gcc-wrapper-*/bin/c++,/nix/store/*-clang-wrapper-*/bin/clang++",
				},
				root_markers = { ".clangd", "compile_commands.json", "compile_flags.txt", ".git" },
			})
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
						diagnostics = { globals = { "Snacks" } },
						workspace = { checkThirdParty = false },
					},
				},
			})
			vim.lsp.config("ruff", { init_options = { settings = { organizeImports = true } } })
			vim.lsp.config("ty", { init_options = { experimental = { useUv = "scripts" } } })
			vim.lsp.enable(servers)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("dene_clangd_health", { clear = true }),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "clangd" then
						require("core.cpp_health").inspect(args.buf, true)
					end
				end,
			})
		end,
	},
	{ "folke/lazydev.nvim", ft = "lua", opts = {} },
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()
			luasnip.filetype_extend("rust", { "rustdoc" })
			luasnip.filetype_extend("python", { "pydoc" })
			cmp.setup({
				completion = { completeopt = "menu,menuone,noinsert" },
				preselect = cmp.PreselectMode.Item,
				sources = cmp.config.sources({
					{ name = "codeium", priority = 80 },
					{ name = "nvim_lsp", priority = 70 },
					{ name = "luasnip", priority = 60 },
					{ name = "path", priority = 50 },
				}, { { name = "buffer", priority = 20 } }),
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
			})
		end,
	},
	{ "https://git.sr.ht/~whynothugo/lsp_lines.nvim", opts = {} },
	{ "folke/trouble.nvim", cmd = "Trouble", opts = {} },
	{ "smjonas/inc-rename.nvim", opts = {} },
}
