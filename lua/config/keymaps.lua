-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<localleader>q", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<localleader>w", "<cmd>w<cr>", { desc = "Write" })
map("n", "<localleader>x", "<C-W>c", { desc = "Close Window" })
map("n", "<localleader>c", function()
  Snacks.bufdelete()
end, { desc = "Close Buffer" })
map("n", "<leader>fd", "<cmd>Telescope bibtex<cr>", { desc = "Find BibTeX Entry" })
