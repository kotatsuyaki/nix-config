{ pkgs, stable }:

let
  kommentary = stable.vimUtils.buildVimPlugin {
    name = "kommentary";
    pname = "kommentary";
    src = pkgs.fetchFromGitHub {
      owner = "b3nj5m1n";
      repo = "kommentary";
      rev = "fe01018a490813a8d89c09947a7ca23fc0e9e728";
      sha256 = "06shsdv92ykf3zx33a7v4xlqfi6jwdpvv9j6hx4n6alk4db02kgd";
    };
  };
  coc-flutter = stable.vimUtils.buildVimPlugin {
    name = "coc-flutter";
    pname = "coc-flutter";
    src = pkgs.fetchFromGitHub {
      owner = "iamcco";
      repo = "coc-flutter";
      rev = "650b7789e15db58c69963196b9b17b560f7fd94b";
      sha256 = "1mzgls3yrpvdxzkby3l4yc2yja63vph7lnsq31qgb1ap448xv231";
    };
  };
in
(pkgs.neovim.override {
  viAlias = true;
  vimAlias = true;
  configure = {
    customRC = builtins.readFile ./vimrc.vim;
    plug.plugins = with stable.vimPlugins; [
      # Appearance
      edge
      barbar-nvim
      lualine-nvim
      # Languages
      vim-nix
      dart-vim-plugin
      vim-toml
      vim-markdown
      rust-vim
      # Basics
      vim-surround
      kommentary
      which-key-nvim
      indent-blankline-nvim-lua
      editorconfig-vim
      vim-rooter
      plenary-nvim
      direnv-vim
      # Intellisense
      coc-nvim
      coc-rust-analyzer
      coc-lists
      coc-pyright
      coc-tabnine
      coc-flutter
      coc-pairs
      coc-clangd
      nvim-colorizer-lua
      vista-vim
      # Git
      lazygit-nvim
      gitsigns-nvim
      neogit
      # Files
      nvim-tree-lua
    ];
  };
})
