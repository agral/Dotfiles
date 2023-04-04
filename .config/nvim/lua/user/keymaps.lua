local opts = {noremap = true, silent = true,}
local keymap = vim.api.nvim_set_keymap

-- Set <Space> as leader key:
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Use ';' as ':':
keymap("n", ";", ":", opts)

-- use <leader>l to toggle search highlighting on/off:
keymap("n", "<leader>l", ":set hlsearch!<CR>", opts)

--[[ "n": Normal mode mappings --]]
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize windows with arrows:
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate the buffers:
keymap("n", "<leader>bn", ":bnext<CR>", opts)
keymap("n", "<leader>bp", ":bprevious<CR>", opts)

keymap("n", "<leader>e", ":Lexplore 30<CR>", opts)

-- Move text up/down:
keymap("n", "<A-j>", ":m .+1<CR>==", opts)
keymap("n", "<A-k>", ":m .-2<CR>==", opts)

--[[ "v": Visual mode mappings --]]
-- Stay in visual mode when indenting:
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up/down:
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Do not substitute the contents of paste register with previous content
-- when pasting into the selected block:
keymap("v", "p", "\"_dP", opts)

--[[ "x": Visual block mode mappings --]]
-- Move text up/down:
keymap("x", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("x", "<A-k>", ":m '>-2<CR>gv=gv", opts)

vim.keymap.set({'n', 'x', 'o'}, 'j', 'gj')
vim.keymap.set({'n', 'x', 'o'}, 'k', 'gk')
