-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo(
		{
			{"HHHHHHHHHHHHHHHHHHHHHHHHHHHH:\n"},
			{"TARAH MAYMKNCH"},
			{" makayn la lazy la ta 9lwa, sir kob lma 3la krchk, zaml"},
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        { import = "plugins" }, -- import plugins
    },
    ui = {border = "single"},
    checker = {notify = false,},
})
