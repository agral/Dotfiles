-- Automatically install neovim-packer:
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = vim.fn.system({"git", "clone", "--depth", "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
  })
  vim.api.nvim_echo({{"[setup info] ", "String"}, {"Packer installed. Please restart Neovim.", "Normal"}}, true, {})
  vim.cmd([[packadd packer.nvim]])
end

local is_good, packer = pcall(require, "packer")
if not is_good then
  vim.api.nvim_echo({{"[setup error] ", "Error"}, {"packer module is missing", "Normal"}}, true, {})
  return
end

packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({border = "rounded"})
    end,
  },
})

-- Adds an autocommand to automatically sync packer on every save of plugins.lua
-- (note: PackerSync == PackerUpdate + PackerCompile)
vim.cmd([[
  augroup packer_nvim_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

return require("packer").startup(
  function(use)
    use "wbthomason/packer.nvim" -- have Packer manage (update) itself

    -- colorscheme:
    use "folke/tokyonight.nvim"

    -- Autocompletion: nvim-cmp
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-buffer"
    --use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-nvim-lua"
    use "hrsh7th/cmp-nvim-lsp"

    -- LSP:
    use "neovim/nvim-lspconfig"
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"

    -- Snippets:
    use "L3MON4D3/LuaSnip" -- snippet completion engine
    use "saadparwaiz1/cmp_luasnip"

    -- Git:
    use "lewis6991/gitsigns.nvim"

    -- Telescope:
    use {
      "nvim-telescope/telescope.nvim",
      requires = {
        {"nvim-lua/plenary.nvim"},
      },
    }

    -- Run PackerSync after cloning packer.nvim for the first time:
    if PACKER_BOOTSTRAP then
      require("packer").sync()
    end
  end
)
