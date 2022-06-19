{ pkgs, ... }:
let
  nlsp-settings-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "nlsp-settings-nvim";
    version = "2022-06-09";
    src = pkgs.fetchFromGitHub {
      owner = "tamago324";
      repo = "nlsp-settings.nvim";
      rev = "527cdfef1b1eb47eb3e6e6f737575a710f307d3a";
      sha256 = "sha256-2xhU9ZmboDAYrHNei+ZbQinDG7wyU8h4V8sL3AE2rmo=";
    };
  };
in
{
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
          vim-opencl
          vim-pandoc-syntax

          # Editing support
          kommentary
          vim-surround
          editorconfig-vim
          indent-blankline-nvim-lua
          which-key-nvim
          nvim-autopairs
          markdown-preview-nvim

          # Git
          lazygit-nvim
          gitsigns-nvim
          git-blame-nvim

          #######
          # LSP #
          #######
          nvim-lspconfig
          nlsp-settings-nvim
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
