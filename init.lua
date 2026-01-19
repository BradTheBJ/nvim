vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.g.mapleader = " "

vim.pack.add({
  {src = "https://github.com/vague2k/vague.nvim"},
  {src = "https://github.com/stevearc/oil.nvim"},
  {src = "https://github.com/echasnovski/mini.pick"},
  {src = "https://github.com/neovim/nvim-lspconfig"},
  {src = "https://github.com/chomosuke/typst-preview.nvim"},
	{src = "https://github.com/altermo/ultimate-autopair.nvim"},
})

vim.lsp.enable({"clangd"})
vim.lsp.enable({"lua_ls"})

require'ultimate-autopair'.setup{}

vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")
