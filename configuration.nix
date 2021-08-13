{ config, pkgs, lib, ... }:

let
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
    config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "sublimetext4"
    ];
  };
  kommentary = pkgs.vimUtils.buildVimPlugin {
    name = "kommentary";
    src = pkgs.fetchFromGitHub {
      owner = "b3nj5m1n";
      repo = "kommentary";
      rev = "fe01018a490813a8d89c09947a7ca23fc0e9e728";
      sha256 = "06shsdv92ykf3zx33a7v4xlqfi6jwdpvv9j6hx4n6alk4db02kgd";
    };
  };
  my-neovim = (unstable.neovim.override {
    viAlias = true;
    vimAlias = true; 
    configure = {
      customRC = ''
        colo edge
        set guifont=Fira\ Code\ Medium:h17
        set termguicolors bg=light
        set et is si ai rnu hls hidden mouse=a ts=4 sts=4 sw=4
        set clipboard=unnamed,unnamedplus
        set updatetime=100
        set nobackup nowritebackup
        set encoding=utf-8
        set cmdheight=2
        set updatetime=300
        set shortmess+=c
        set ignorecase smartcase
        set inccommand=nosplit

        nnoremap <leader>; A;
        inoremap <leader>; <Esc>A;

        " Disable nvim tree icons
        let g:nvim_tree_show_icons = {
            \ 'git': 0,
            \ 'folders': 0,
            \ 'files': 0,
            \ 'folder_arrows': 0,
            \ }

        nn ; :
        vn ; :
        nn <silent> <CR> :noh<CR><CR>
        syn on
        filet plugin indent on

        " Setup git gutter
        lua require('gitsigns').setup()

        " Setup nvim-autopairs
        lua require('nvim-autopairs').setup{}

        " Project-specific rust-analyzer path (to avoid installing it globally)
        if executable('rust-analyzer')
          call coc#config('rust-analyzer', {'server': {'path': trim(system('which rust-analyzer'))}})
        endif

        " Recommended settings according to barbar
        let bufferline = get(g:, 'bufferline', {})
        let bufferline.icons = 'numbers'
        let bufferline.icon_close_tab = '✕'

        " Move to previous/next
        nnoremap <silent>    <A-,> :BufferPrevious<CR>
        nnoremap <silent>    <A-.> :BufferNext<CR>
        " Re-order to previous/next
        nnoremap <silent>    <A-<> :BufferMovePrevious<CR>
        nnoremap <silent>    <A->> :BufferMoveNext<CR>
        " Goto buffer in position...
        nnoremap <silent>    <A-1> :BufferGoto 1<CR>
        nnoremap <silent>    <A-2> :BufferGoto 2<CR>
        nnoremap <silent>    <A-3> :BufferGoto 3<CR>
        nnoremap <silent>    <A-4> :BufferGoto 4<CR>
        nnoremap <silent>    <A-5> :BufferGoto 5<CR>
        nnoremap <silent>    <A-6> :BufferGoto 6<CR>
        nnoremap <silent>    <A-7> :BufferGoto 7<CR>
        nnoremap <silent>    <A-8> :BufferGoto 8<CR>
        nnoremap <silent>    <A-9> :BufferLast<CR>
        " Pin/unpin buffer
        nnoremap <silent>    <A-p> :BufferPin<CR>
        " Close buffer
        nnoremap <silent>    <A-c> :BufferClose<CR>
        " Wipeout buffer
        "                          :BufferWipeout<CR>
        " Close commands
        "                          :BufferCloseAllButCurrent<CR>
        "                          :BufferCloseAllButPinned<CR>
        "                          :BufferCloseBuffersLeft<CR>
        "                          :BufferCloseBuffersRight<CR>
        " Magic buffer-picking mode
        nnoremap <silent> <C-s>    :BufferPick<CR>
        " Sort automatically by...
        nnoremap <silent> <Space>bd :BufferOrderByDirectory<CR>
        nnoremap <silent> <Space>bl :BufferOrderByLanguage<CR>
        nnoremap <silent> <Space>bw :BufferOrderByWindowNumber<CR>

        " Recommended settings according to coc
        set signcolumn=yes

        inoremap <silent><expr> <TAB>
              \ pumvisible() ? "\<C-n>" :
              \ <SID>check_back_space() ? "\<TAB>" :
              \ coc#refresh()
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

        function! s:check_back_space() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction

        if has('nvim')
          inoremap <silent><expr> <c-space> coc#refresh()
        else
          inoremap <silent><expr> <c-@> coc#refresh()
        endif

        inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

        nmap <silent> [g <Plug>(coc-diagnostic-prev)
        nmap <silent> ]g <Plug>(coc-diagnostic-next)

        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)

        nnoremap <silent> K :call <SID>show_documentation()<CR>

        function! s:show_documentation()
          if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
          elseif (coc#rpc#ready())
            call CocActionAsync('doHover')
          else
            execute '!' . &keywordprg . " " . expand('<cword>')
          endif
        endfunction

        autocmd CursorHold * silent call CocActionAsync('highlight')

        nmap <leader>rn <Plug>(coc-rename)

        xmap <leader>f  <Plug>(coc-format-selected)
        nmap <leader>f  <Plug>(coc-format-selected)

        augroup mygroup
          autocmd!
          autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
          autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
        augroup end

        xmap <leader>a  <Plug>(coc-codeaction-selected)
        nmap <leader>a  <Plug>(coc-codeaction-selected)

        nmap <leader>ac  <Plug>(coc-codeaction)
        nmap <leader>qf  <Plug>(coc-fix-current)

        xmap if <Plug>(coc-funcobj-i)
        omap if <Plug>(coc-funcobj-i)
        xmap af <Plug>(coc-funcobj-a)
        omap af <Plug>(coc-funcobj-a)
        xmap ic <Plug>(coc-classobj-i)
        omap ic <Plug>(coc-classobj-i)
        xmap ac <Plug>(coc-classobj-a)
        omap ac <Plug>(coc-classobj-a)

        if has('nvim-0.4.0') || has('patch-8.2.0750')
          nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
          inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
          inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
          vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        endif

        nmap <silent> <C-s> <Plug>(coc-range-select)
        xmap <silent> <C-s> <Plug>(coc-range-select)

        command! -nargs=0 Format :call CocAction('format')

        command! -nargs=? Fold :call     CocAction('fold', <f-args>)

        command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

        set statusline^=%{coc#status()}%{get(b:,'coc_current_function',''')}

        nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
        nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
        nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
        nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
        nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
        nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
        nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
        nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
        nnoremap <silent><nowait> <space>f  :<C-u>CocList files<CR>

        " lualine
        lua << EOF
        require('lualine').setup {
          options = {
            icons_enabled = false,
            component_separators = ''',
            section_separators = ''',
            theme = 'onelight'
          },
          sections = {
            lualine_y = {
              'progress',
              {
                'diagnostics',
                sources = { 'coc' },
                color_error = '#d05858',
                color_warn = '#be7e05',
                color_info = '#4b505b',
                color_hint = '#4b505b'
              }
            }
          }
        }
        EOF
      '';
      packages.myPlugins = with pkgs.vimPlugins; {
        start = [
          # Appearance
          edge barbar-nvim lualine-nvim
          # Languages
          vim-nix dart-vim-plugin vim-toml
          # Basics
          vim-surround nvim-autopairs kommentary which-key-nvim
          # Intellisense
          coc-nvim coc-rust-analyzer coc-lists
          # Git
          lazygit-nvim gitsigns-nvim
          # Files
          nvim-tree-lua
        ];
        opt = [];
      };
    };
  });
in {
  ### Local config files ###
  # hardware-configuration.nix should be generated during install.
  # hostname.nix must contain ` networking.hostName = "rx570-nixos"; `.
  imports = [
    /etc/nixos/hardware-configuration.nix
    /etc/nixos/hostname.nix
    /etc/nixos/cachix.nix
  ];

  config = lib.mkMerge [{
    ### Packages ###
    environment.systemPackages = with pkgs; [
      # web
      chromium tdesktop thunderbird birdtray teams
      # office
      libreoffice lyx
      # gui devtools
      alacritty grpcui 
      # game
      minecraft
      # Sublime 
      unstable.sublime4 sublime-merge

      # cli system-wide tools
      curl fzf git htop lazygit p7zip ripgrep wget zsh
      aria2 tmux python3 nodejs unzip

      # terminal file manager
      ranger ueberzug

      # desktop utilities
      wmctrl xdotool play-with-mpv xsel

      # kde utilities
      kwallet-pam plasma-browser-integration libnotify ark unrar libappindicator-gtk3
      plasma5Packages.kio-extras

      # media
      mpc_cli mpd mpdris2 mpv ncmpcpp ffmpeg imagemagick
      zathura gimp unstable.musescore feh

      # sync
      syncthing

      # texlive
      texlive.combined.scheme-full

      # theme gtk apps properly
      gnome.adwaita-icon-theme

      # virtualization & container
      libvirt virt-manager podman appimage-run

      # for lorri
      direnv

      # customized vim
      my-neovim
      (unstable.neovim-qt.override {
        neovim = my-neovim;
      })
    ];

    # Font packages
    fonts.fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      source-han-serif
      fira-code
      fira-mono
    ];

    # Allow some nonfree packages
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "minecraft-launcher" "unrar" "nvidia-x11" "nvidia-settings" "nvidia-persistenced" "cudatoolkit"
      "libtorch" "pytorch" "teams" "sublime-merge" "unzip"
    ];

    ### Basics ###
    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Networking
    networking.useDHCP = false;
    networking.networkmanager.enable = true;
    networking.firewall.enable = false;
    networking.networkmanager.insertNameservers = [ "8.8.8.8" "8.8.4.4" ];

    # Firmware thing
    hardware.enableRedistributableFirmware = true;

    # Decrease systemd timeout
    systemd.extraConfig = ''
      DefaultTimeoutStopSec=15s
    '';

    ### X settings ###
    services.xserver.enable = true;
    services.xserver.xkbOptions = "altwin:swap_alt_win";
    # KDE Plasma
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;
    # Touchpad
    services.xserver.libinput.enable = true;
    # Printers
    services.printing.enable = true;
    # Audio
    hardware.pulseaudio.enable = true;
    sound.enable = true;

    # Lorri
    services.lorri.enable = true;

    ### MPD ###
    hardware.pulseaudio.extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";
    services.mpd = {
      enable = true;
      user = "akitaki";
      group = "users";
      extraConfig = ''
        music_directory "/home/akitaki/Music"
        follow_outside_symlinks "yes"
        follow_inside_symlinks "yes"
        audio_output {
            type "pulse"
            name "Pulseaudio"
            server "127.0.0.1"
        }
      '';
    };

    ### User ###
    users.users.akitaki = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "input" ];
      shell = pkgs.zsh;
    };

    ### System env ###
    environment.variables.EDITOR = "nvim";
    system.stateVersion = "21.05";
    environment.etc = {
      # Set git commit --verbose as default
      gitconfig = {
        text = ''
          [commit]
          verbose = true
        '';
        mode = "444";
      };
    };

    ### Virtualisation
    virtualisation = {
      libvirtd.enable = true;
      podman = {
        enable = true;
        enableNvidia = true;
      };
    };

    ### Syncthing ###
    services.syncthing = {
      enable = true;
      user = "akitaki";
      dataDir = "/home/akitaki/Sync";
      configDir = "/home/akitaki/.config/syncthing";
    };

    ### Localization ###
    time.timeZone = "Asia/Taipei";
    i18n = {
      defaultLocale = "en_US.UTF-8";
      supportedLocales = [ "en_US.UTF-8/UTF-8" "zh_TW.UTF-8/UTF-8" "ja_JP.UTF-8/UTF-8" ];
      inputMethod = {
        enabled = "fcitx5";
        fcitx5.addons = with pkgs; [
          fcitx5-mozc
          fcitx5-rime
          fcitx5-gtk
          fcitx5-configtool
        ];
      };
    };
  } (lib.mkIf (config.networking.hostName == "x13-nixos") {
    environment.systemPackages = with pkgs; [
      fprintd libinput-gestures tlp
    ];

    # Larger tty font
    console.font = "ter-132n";
    console.packages = with pkgs; [
      terminus
    ];

    # TLP
    services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNER_ON_BAT = "powersave";
        CPU_SCALING_GOVERNER_ON_AC = "performance";
      };
    };

    # Fingerprint
    services.fprintd.enable = true;
  }) (lib.mkIf (config.networking.hostName == "rtx3070-nixos") {
    environment.systemPackages = with pkgs; [
      nvidia-docker nvidia-podman cudatoolkit_11_1 cudnn_cudatoolkit_11_1
      python3Packages.pytorch-bin nvtop
      (libtorch-bin.override { cudaSupport = true; })
    ];

    # Nvidia driver
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.opengl.enable = true;
    hardware.opengl.driSupport32Bit = true;
    # ssh server
    services.sshd.enable = true;
    services.openssh.ports = import /etc/nixos/ssh-ports.nix;
    services.openssh.forwardX11 = true;
    programs.ssh.forwardX11 = true;
    programs.ssh.setXAuthLocation = true;
  })];
}

