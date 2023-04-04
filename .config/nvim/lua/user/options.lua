vim.opt.backup = false
vim.opt.breakindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 1
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.conceallevel = 0
vim.opt.cursorline = true
vim.opt.fileencoding = "utf-8"
vim.opt.guifont = "monospace:h16"
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.mouse = ""        -- disable mouse support completely.
vim.opt.termguicolors = true

-- indentation:
vim.opt.expandtab = true
vim.opt.shiftwidth = 2    -- use two spaces for every indentation level
vim.opt.tabstop = 2       -- insert two spaces for a tab

-- numberline-related options
vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.relativenumber = false

-- height of a pop-up menu:
vim.opt.pumheight = 10

vim.opt.scrolloff = 7
vim.opt.sidescrolloff = 7

-- omit all ins-completion-menu messages (like: "match 1 of 3", "Pattern not found", etc.):
vim.opt.shortmess:append("c")

-- do not show current mode (NORMAL/INSERT/VISUAL/...)
vim.opt.showmode = false

-- show tab names, but only if at least two tabs are present.
vim.opt.showtabline = 1

-- always show the sign column, even with no issues to indicate:
vim.opt.signcolumn = "yes"

vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false

-- time to wait for a mapped key sequence to complete, in milliseconds:
vim.opt.timeoutlen = 1000

-- enable persistent undo
vim.opt.undofile = true

-- completion engine timeout, in milliseconds. Default: 4000. Smaller timeout is faster.
vim.opt.updatetime = 300

vim.opt.wrap = true
vim.opt.writebackup = false

-- make nvim treat '-' character as part of the keyword (default: separator).
-- this lets for more natural handling of hyphen-case-keywords.
vim.cmd [[set iskeyword+=-]]
