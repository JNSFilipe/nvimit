#!/bin/bash

mkdir -p ~/.config/nvim/lua/user
ln -s ./init.lua ~/.config/nvim/init.lua
ln -s ./misc.lua ~/.config/nvim/lua/user/misc.lua
ln -s ./theme.lua ~/.config/nvim/lua/user/theme.lua
ln -s ./coding.lua ~/.config/nvim/lua/user/coding.lua
ln -s ./keymaps.lua ~/.config/nvim/lua/user/keymaps.lua
ln -s ./options.lua ~/.config/nvim/lua/user/options.lua
ln -s ./plugins.lua ~/.config/nvim/lua/user/plugins.lua
ln -s ./filetree.lua ~/.config/nvim/lua/user/filetree.lua
ln -s ./terminal.lua ~/.config/nvim/lua/user/terminal.lua
ln -s ./whichkey.lua ~/.config/nvim/lua/user/whichkey.lua
ln -s ./options.lua ~/.config/nvim/lua/user/options.lua
ln -s ./packerbootstrap.lua ~/.config/nvim/lua/user/packerbootstrap.lua

echo "NVIMIT installed sucessfully!"

