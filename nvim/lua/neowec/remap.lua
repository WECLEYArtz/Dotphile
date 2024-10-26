vim.g.mapleader = " "

-- colemak better motion 
vim.keymap.set({"n","v"}, "n","j", {noremap = true})
vim.keymap.set({"n","v"}, "e","k", {noremap = true})
vim.keymap.set({"n","v"}, "i","l", {noremap = true})

-- vim.keymap.set({"n","v","i"}, "<leader><leader>","<cr>")

vim.keymap.set("n", "<leader>e", function()
    vim.cmd.Neotree("reveal")
end)

vim.keymap.set({"n","v","i"}, "<leader>c","<ESC>")
vim.keymap.set({"n"},"U","<C-r>")

-- no highlight
vim.keymap.set({"n","v"}, "<leader>no",vim.cmd.nohl)

-- tabs
vim.keymap.set({"n"}, "<leader>tn",vim.cmd.tabnew)
vim.keymap.set({"n"}, "<leader>tc",vim.cmd.tabclose)
vim.keymap.set({"n"}, "<leader>ti",vim.cmd.tabnext)
vim.keymap.set({"n"}, "<leader>th",vim.cmd.tabprevious)
