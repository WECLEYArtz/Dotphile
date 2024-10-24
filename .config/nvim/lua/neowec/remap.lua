vim.g.mapleader = " "

vim.keymap.set({"n","v"}, "n","j", {noremap = true})
vim.keymap.set({"n","v"}, "e","k", {noremap = true})
vim.keymap.set({"n","v"}, "i","l", {noremap = true})

vim.keymap.set({"n","v","i"}, "<leader><leader>","<cr>")

vim.keymap.set("n", "<leader>e", function()
    vim.cmd.Neotree("reveal")
end)

vim.keymap.set({"n","v","i"}, "<leader>c","<ESC>")
vim.keymap.set({"n", "v"},"U","<C-r>")
-- colemak better motion 


vim.keymap.set({"n","v"}, "<leader>no",vim.cmd.nohl)
