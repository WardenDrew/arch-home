-- General settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.showbreak = '↪'
vim.opt.list = true
vim.opt.listchars:append({ 
  space = '·', 
  tab = '→ ', 
  -- eol = '↲', 
  nbsp = '␣', 
  extends = '…', 
  precedes = '…', 
  trail = '·' 
})
vim.opt.wrap = false

-- Start in Insert Mode
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*",
  command = "startinsert",
})

-- Line Numbering
-- Shows absolute numbers in Insert Mode
-- Otherwise shows current line and relative offsets from it
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  pattern = "*",
  command = ":setlocal norelativenumber",
})
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  pattern = "*",
  command = ":setlocal relativenumber",
})

-- Load vim-plug for plugin management
local Plug = vim.fn['plug#']
vim.call('plug#begin')
Plug('OXY2DEV/markview.nvim')
vim.call('plug#end')

-- Markdown indent formatting to override prepackaged defaults
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- Markview plugin list indents
require("markview").setup({
  markdown = {
    list_items = {
      indent_size = 0,
      shift_width = 1
    }
  }
})
