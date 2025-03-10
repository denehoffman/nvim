-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.wrap = true
vim.opt.relativenumber = false
vim.opt.tabstop = 4

vim.g.lazyvim_rust_diagnostics = "bacon-ls"
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"
vim.g.vimtex_view_method = "sioyek"

vim.g.vimtex_syntax_custom_cmds_with_concealed_delims = {
  { name = "bra", mathmode = 1, cchar_open = "⟨", cchar_close = "|" },
  { name = "ket", mathmode = 1, cchar_open = "|", cchar_close = "⟩" },
  { name = "ip", nargs = 2, mathmode = 1, cchar_open = "⟨", cchar_mid = "|", cchar_close = "⟩" },
  { name = "dyad", nargs = 2, mathmode = 1, cchar_open = "|", cchar_mid = "╳", cchar_close = "|" },
  { name = "frac", nargs = 2, mathmode = 1, cchar_open = "(", cchar_mid = "∕", cchar_close = ")" },
}

vim.g.lazyvim_cmp = "nvim-cmp"
