return {
    "EdenEast/nightfox.nvim",
    config = function()
        require('nightfox').setup({
            options = {
                compile_file_suffix = "_compiled", -- Compiled file suffix
                -- transparent = false,
                terminal_colors = true,
                dim_inactive = false,    -- Non focused panes set to alternative background

                styles = {               -- Style to be applied to different syntax groups
                    comments = "NONE",     -- Value is any valid attr-list value `:help attr-list`
                    conditionals = "NONE",
                    constants = "NONE",
                    functions = "NONE",
                    keywords = "NONE",
                    numbers = "NONE",
                    operators = "NONE",
                    strings = "NONE",
                    types = "NONE",
                    variables = "NONE",
                },
            },
        })
    end,
}
