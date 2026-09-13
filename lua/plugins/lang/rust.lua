return {
	{
		"mrcjkb/rustaceanvim",
		version = "^9",
		lazy = false,
		init = function()
			vim.g.rustaceanvim = {
				server = {
					default_settings = {
						["rust-analyzer"] = {
							check = { command = "clippy", workspace = true, allTargets = true },
							inlayHints = { closureReturnTypeHints = { enable = "with_block" } },
						},
					},
				},
			}
		end,
	},
	{ "saecki/crates.nvim", event = { "BufRead Cargo.toml" }, opts = {} },
}
