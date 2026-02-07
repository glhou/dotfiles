return {
    {
        "nvim-mini/mini.files",
        lazy = false,
        opts = {
            options = {
                use_as_default_explorer = true,
            },
        },
    },
    {
        "folke/snacks.nvim",
        opts = {
            explorer = { enabled = false },
        },
    },
}
