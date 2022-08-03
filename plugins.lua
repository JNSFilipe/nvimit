return require('packer').startup(function(use)
  -- My plugins here
  -- use 'foo1/bar1.nvim'
  -- use 'foo2/bar2.nvim'
  
  -- Plugin Mangager
  use "wbthomason/packer.nvim" -- Have packer manage itself

  -- Which Key, this config is built around it
  use "folke/which-key.nvim"

  -- File Explorer
  use {"kyazdani42/nvim-tree.lua", requires={'kyazdani42/nvim-web-devicons'}} -- 'kyazdani42/nvim-web-devicons' is optional, for file icons

  -- Themes
  use 'shaunsingh/nord.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

