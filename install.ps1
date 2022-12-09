$FolderName = "$env:LOCALAPPDATA\nvim"

if (Test-Path $FolderName) {
    Write-Host "Folder Exists"
    # Perform Delete file from folder operation
}
else
{ 
    #PowerShell Create directory if not exists
    New-Item $FolderName -ItemType Directory
    Write-Host "Folder Created successfully"
}

$FolderName = "$env:LOCALAPPDATA\nvim\lua"

if (Test-Path $FolderName) {
    Write-Host "Folder Exists"
    # Perform Delete file from folder operation
}
else
{ 
    #PowerShell Create directory if not exists
    New-Item $FolderName -ItemType Directory
    Write-Host "Folder Created successfully"
}

$FolderName = "$env:LOCALAPPDATA\nvim\lua\user"

if (Test-Path $FolderName) {
    Write-Host "Folder Exists"
    # Perform Delete file from folder operation
}
else
{ 
    #PowerShell Create directory if not exists
    New-Item $FolderName -ItemType Directory
    Write-Host "Folder Created successfully"
}

New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim\init.lua" -Target "$(pwd)\init.lua"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim\lua\user\misc.lua" -Target "$(pwd)\misc.lua"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim\lua\user\langs.lua" -Target "$(pwd)\langs.lua"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim\lua\user\theme.lua" -Target "$(pwd)\theme.lua"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim\lua\user\coding.lua" -Target "$(pwd)\coding.lua"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim\lua\user\keymaps.lua" -Target "$(pwd)\keymaps.lua"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim\lua\user\options.lua" -Target "$(pwd)\options.lua"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim\lua\user\plugins.lua" -Target "$(pwd)\plugins.lua"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim\lua\user\filetree.lua" -Target "$(pwd)\filetree.lua"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim\lua\user\terminal.lua" -Target "$(pwd)\terminal.lua"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim\lua\user\whichkey.lua" -Target "$(pwd)\whichkey.lua"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim\lua\user\navigation.lua" -Target "$(pwd)\navigation.lua"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim\lua\user\packerbootstrap.lua" -Target "$(pwd)\packerbootstrap.lua"

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo "NVIMIT installed sucessfully!"