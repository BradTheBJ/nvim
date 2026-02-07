local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.wrap = false

require("lazy").setup({
    spec = {
        {
            "rebelot/kanagawa.nvim",
            config = function()
                require("kanagawa").setup({ style = "dragon" })
                vim.cmd("colorscheme kanagawa")
            end,
        },
        {
            "williamboman/mason.nvim",
            config = function()
                require("mason").setup()
            end,
        },
        {
            "williamboman/mason-lspconfig.nvim",
            config = function()
                require("mason-lspconfig").setup({
                    ensure_installed = { "clangd", "pyright" },
                })
            end,
        },
        {
            "neovim/nvim-lspconfig",
            config = function()
                local lspconfig = require("lspconfig")

                lspconfig.clangd.setup{}
                lspconfig.pyright.setup{}

                vim.diagnostic.config({
                    virtual_text = { spacing = 2, prefix = "●" },
                    signs = true,
                    underline = true,
                    update_in_insert = false,
                })

                vim.cmd [[
                    autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, { focusable = false })
                ]]
            end,
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            lazy = false,
            config = function()
                local ok, tsconfigs = pcall(require, "nvim-treesitter.configs")
                if not ok then return end

                tsconfigs.setup({
                    ensure_installed = { "go", "lua", "c", "cpp", "zig", "python" },
                    highlight = { enable = true },
                    indent = { enable = true },
                    incremental_selection = { enable = true },
                    textobjects = { enable = true },
                })
            end,
        },
    },
    install = { colorscheme = { "habamax" } },
    checker = { enabled = true },
})

