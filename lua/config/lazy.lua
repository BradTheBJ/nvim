-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.wrap = false

-- Keymaps
-- Save current file only if it has a name
vim.keymap.set('n', '<leader>s', function()
    if vim.fn.expand('%') ~= '' then
        vim.cmd('write')
    else
        vim.api.nvim_echo({{'Buffer has no name, cannot save', 'WarningMsg'}}, true, {})
    end
end)

vim.keymap.set('n', '<leader>q', ':quit<CR>')

-- Setup lazy.nvim plugins
require("lazy").setup({
    spec = {
        {
            "rebelot/kanagawa.nvim",
            config = function()
                require("kanagawa").setup({ style = "wave" })
                vim.cmd("colorscheme kanagawa")
            end,
        },
    },
    install = { colorscheme = { "habamax" } },
    checker = { enabled = true },
})
 
