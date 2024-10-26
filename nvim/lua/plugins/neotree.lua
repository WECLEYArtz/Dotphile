return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function ()
        require("neo-tree").setup({
            buffers = {
                follow_current_file = {
                    enable = true,
                },
            },
            window = {
                mappings = {
                    ["="] = "toggle_auto_expand_width" ,
                    ["e"] = "noop", -- allow motion remap to work
                }
            }
        })
    end,
}
