local keymap = vim.keymap

-- Select all
keymap.set("n", "<leader>a", "gg<S-v>G")

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da")
keymap.set("n", "<Leader>O", "O<Esc>^Da")

-- fomating and utils
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")
keymap.set("n", "J", "mzJ`z")

keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

keymap.set({ "n", "v" }, "<leader>d", [["_d]])
keymap.set("n", "x", '"_x')

keymap.set("n", "Q", "<nop>")

keymap.set("n", "<leader>f", vim.lsp.buf.format)
keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = true })
keymap.set("n", "<Leader>o", ":call append(line('.'), '')<CR>", { noremap = true, silent = true })
