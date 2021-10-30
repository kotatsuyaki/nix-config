{ pkgs }:

let
  makePlugin = { name, path, preConfigure ? "" }: pkgs.vimUtils.buildVimPlugin {
    name = name;
    pname = name;
    src = import path;
    preConfigure = preConfigure;
  };
  surround-nvim = makePlugin { name = "surround-nvim"; path = ./nvim-plugins/surround.nvim.nix; };
  vscode-nvim = makePlugin { name = "vscode-nvim"; path = ./nvim-plugins/vscode.nvim.nix; };
  cmp-nvim-lsp = makePlugin { name = "cmp-nvim-lsp"; path = ./nvim-plugins/cmp-nvim-lsp.nix; };
  nvim-code-action-menu = makePlugin { name = "nvim-code-action-menu"; path = ./nvim-plugins/nvim-code-action-menu.nix; };
in
(pkgs.neovim.override {
  viAlias = true;
  vimAlias = true;
  configure = {
    customRC = ''
      lua << EOF
      ${builtins.readFile ./nvim-init.lua}
      EOF
    '';
    packages.myVimPackage = {
      start = with pkgs.vimPlugins; [
        # Appearance
	    vscode-nvim
        bufferline-nvim
        lualine-nvim
        nvim-colorizer-lua

        # Language syntax
        (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))

        # Editing support
	    kommentary
        surround-nvim
        editorconfig-vim
        indent-blankline-nvim-lua
        which-key-nvim
        nvim-autopairs

        # Git
        lazygit-nvim
        gitsigns-nvim

        #######
        # LSP #
        #######
        nvim-lspconfig
        # cmp
        nvim-cmp
        cmp-nvim-lsp
        cmp_luasnip
        cmp-path
        luasnip
        # diag
        trouble-nvim
        # help
        lsp_signature-nvim
        nvim-code-action-menu
        # fuzzy search
        fzf-lsp-nvim
        fzf-vim
      ];
      opt = [ ];
    };
  };
})
