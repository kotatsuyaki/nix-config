#!/bin/sh
prefetch() {
    user=$1
    repo=$2
    if [ -e "$repo.nix" ]; then
        echo "$user/$repo already exists"
    else
        echo "fetching $user/$repo"
        nix-prefetch-github --nix --no-fetch-submodules $user $repo \
            | sed -e 's/<nixpkgs>/<nixos-unstable>/g' \
            > $repo.nix
    fi
}
prefetch blackCauldron7 surround.nvim
prefetch Mofiqul vscode.nvim
prefetch hrsh7th cmp-nvim-lsp
prefetch weilbith nvim-code-action-menu
prefetch EdenEast nightfox.nvim

# prefetch rafcamlet nvim-luapad
# prefetch ray-x navigator.lua
# prefetch ray-x guihua.lua
