-- lazy.lua

-- Bootstrap lazy.nvim
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

-- Global options
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.wrap = false

-- Keymaps
vim.keymap.set('n', '<leader>w', function() vim.cmd('write') end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q', function() vim.cmd('quit') end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>t', function() vim.cmd('Telescope find_files') end, { noremap = true, silent = true })
-- Plugin setup
require("lazy").setup({
    spec = {
        -- Colorscheme
        {
            "rebelot/kanagawa.nvim",
            config = function()
                require("kanagawa").setup({ style = "dragon" })
                vim.cmd("colorscheme kanagawa")
            end,
        },

        -- Mason and LSP
        {
            "williamboman/mason.nvim",
            config = function() require("mason").setup() end,
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

        -- Treesitter
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

        -- Telescope
        {
            'nvim-telescope/telescope.nvim', version = '*',
            dependencies = {
                'nvim-lua/plenary.nvim',
                { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            },
        },

        -- nvim-cmp and completion
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-cmdline",
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",
            },
            config = function()
                local cmp = require("cmp")
                local luasnip = require("luasnip")

                cmp.setup({
                    snippet = {
                        expand = function(args)
                            luasnip.lsp_expand(args.body)
                        end,
                    },
                    mapping = cmp.mapping.preset.insert({
                        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                        ["<C-f>"] = cmp.mapping.scroll_docs(4),
                        ["<C-Space>"] = cmp.mapping.complete(),
                        ["<C-e>"] = cmp.mapping.abort(),
                        ["<CR>"] = cmp.mapping.confirm({ select = true }),
                        ["<Tab>"] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item()
                            elseif luasnip.expand_or_jumpable() then
                                luasnip.expand_or_jump()
                            else
                                fallback()
                            end
                        end, { "i", "s" }),
                        ["<S-Tab>"] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item()
                            elseif luasnip.jumpable(-1) then
                                luasnip.jump(-1)
                            else
                                fallback()
                            end
                        end, { "i", "s" }),
                    }),
                    sources = cmp.config.sources({
                        { name = "nvim_lsp" },
                        { name = "luasnip" },
                    }, {
                        { name = "buffer" },
                        { name = "path" },
                    }),
                })

                -- Command-line completion
                cmp.setup.cmdline("/", {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = { { name = "buffer" } },
                })
                cmp.setup.cmdline(":", {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = cmp.config.sources({
                        { name = "path" }
                    }, {
                        { name = "cmdline" }
                    }),
                })
            end,
        },
    },

    install = { colorscheme = { "habamax" } },
    checker = { enabled = true },
})
