-- Simplified function to change keybindings
local function keymap(mode, keybind, action)

  local opts = { noremap = true, silent = true }	-- chris@machine says so (https://youtu.be/Vghglz2oR0c?t=2482)
  -- local term_opts = { silent = true }

  -- local keymap = vim.api.nvim_set_keymap
  vim.keymap.set(mode, keybind, action, opts)

end

--Remap space as leader key
keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
-- vim.g.maplocalleader = " "
-- keymap("n", "<C-Space>", "<cmd>WhichKey \\<leader><cr>")
-- keymap("n", "<C-i>", "<C-i>")

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<m-h>", "<C-w>h")
keymap("n", "<m-h>", "<C-w>h")
keymap("n", "<m-j>", "<C-w>j")
keymap("n", "<m-k>", "<C-w>k")
keymap("n", "<m-l>", "<C-w>l")

-- Tabs --
keymap("n", "<m-t>", ":tabnew %<cr>")
keymap("n", "<m-y>", ":tabclose<cr>")
keymap("n", "<m-\\>", ":tabonly<cr>")

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>")
keymap("n", "<C-Down>", ":resize +2<CR>")
keymap("n", "<C-Left>", ":vertical resize -2<CR>")
keymap("n", "<C-Right>", ":vertical resize +2<CR>")

-- Insert --
-- Remap Esc to jj
keymap("i", "jj", "<Esc>")

