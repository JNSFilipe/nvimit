#!/bin/bash

mkdir -p ~/.config/nvim/lua/user
ln -s $(pwd)/init.lua ~/.config/nvim/init.lua
ln -s $(pwd)/misc.lua ~/.config/nvim/lua/user/misc.lua
ln -s $(pwd)/theme.lua ~/.config/nvim/lua/user/theme.lua
ln -s $(pwd)/coding.lua ~/.config/nvim/lua/user/coding.lua
ln -s $(pwd)/keymaps.lua ~/.config/nvim/lua/user/keymaps.lua
ln -s $(pwd)/options.lua ~/.config/nvim/lua/user/options.lua
ln -s $(pwd)/plugins.lua ~/.config/nvim/lua/user/plugins.lua
ln -s $(pwd)/filetree.lua ~/.config/nvim/lua/user/filetree.lua
ln -s $(pwd)/terminal.lua ~/.config/nvim/lua/user/terminal.lua
ln -s $(pwd)/whichkey.lua ~/.config/nvim/lua/user/whichkey.lua
ln -s $(pwd)/packerbootstrap.lua ~/.config/nvim/lua/user/packerbootstrap.lua

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo "NVIMIT installed sucessfully!"

