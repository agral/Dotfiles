-- Automatically install lazy.nvim plugin manager:
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
    local lazy_addr = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({"git", "clone", "--filter=blob:none", lazy_addr, "--branch=stable", lazy_path })
    vim.api.nvim_echo({{"[setup info] ", "String"}, {"Lazy package manager installed. Please restart Neovim.", "Normal"}}, true, {})
end

vim.opt.rtp:prepend(lazy_path)

local is_good, lazy_plugin = pcall(require, "lazy")
if not is_good then
  vim.api.nvim_echo({{"[setup error] ", "Error"}, {"lazy.nvim module is missing", "Normal"}}, true, {})
  return
end

lazy_plugin.setup("plugins", {
    change_detection = {
        enabled = true,
        notify = false,
    },
    ui = {
        -- if NF available, use empty array - it will be overridden. Otherwise define base Unicode icons:
        icons = vim.g.have_nerd_font and {} or {
            cmd = '⌘',
            config = '🛠',
            event = '📅',
            ft = '📂',
            init = '⚙',
            keys = '🗝',
            plugin = '🔌',
            runtime = '💻',
            require = '🌙',
            source = '📄',
            start = '🚀',
            task = '📌',
            lazy = '💤 ',
        },
    },
})
