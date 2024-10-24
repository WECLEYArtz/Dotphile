vim.cmd("colorscheme carbonfox")
vim.cmd("AirlineTheme simple")

local dark = "#020202"
-- local nc = "#0a0a0a"
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalNC", { bg = nc })

vim.api.nvim_set_hl(0, "NeoTreeNormal" , { bg =  dark })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = dark })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = dark })

-- the rest of the theming exists in thier plugin configs
