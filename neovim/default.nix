{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    configure = {
      customRC = ''
        lua << EOF
        ${builtins.readFile ./init.lua}
        EOF
      '';
      packages.myVimPackage = {
        start = with pkgs.vimPlugins; [
          # Appearance
          nightfox-nvim
          bufferline-nvim
          lualine-nvim
          nvim-colorizer-lua
          nvim-web-devicons

          # Language syntax
          nvim-treesitter
          vim-glsl

          # Editing support
          kommentary
          vim-surround
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
  };
}
