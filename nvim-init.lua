function config_builtin_options()
    options = {
        guifont = 'Fira Code Medium:h17',
        bg = 'light',
        clipboard ='unnamed,unnamedplus',
        completeopt = 'menu,menuone,noselect',
        updatetime = 100,
        encoding = 'utf-8',
        cmdheight = 2,
        updatetime = 300,
        inccommand = 'nosplit',
		mouse = 'a',
        ts = 4,
        sts = 4,
        sw = 4,
        signcolumn = 'yes',
    }

    for key, value in pairs(options) do
        vim.opt[key] = value
    end

    enable_options = {
        'et',
        'is',
        'si',
        'ai',
        'rnu',
        'hls',
        'hidden',
        'ignorecase',
        'smartcase',
        'termguicolors',
    }

    for i = 1, #enable_options do
        vim.opt[enable_options[i]] = true
    end

    disable_options = {
        'backup',
        'writebackup',
    }

    for i = 1, #disable_options do
        vim.opt[disable_options[i]] = false
    end

    -- hide completion messages
    vim.opt.shortmess:append('c')
end
config_builtin_options()

function config_colors()
    -- colorscheme
    vim.g.vscode_style = 'light'
    vim.cmd[[colo vscode]]

    -- make vertical lines less distracting
    vim.cmd('au VimEnter * highlight IndentBlanklineChar guifg=#EEF1F4 gui=nocombine')
    vim.cmd('au VimEnter * highlight MatchParen guibg=#dddddd')

    -- make errors hurt my eyes less
    -- wrong code highlight
    vim.cmd('au VimEnter * highlight Error guifg=#A31515')
    vim.cmd('au VimEnter * highlight LspDiagnosticsUnderlineError guifg=#A31515')
    -- error messages
    vim.cmd('au VimEnter * highlight LspDiagnosticsDefaultError guifg=#A31515')
    vim.cmd('au VimEnter * highlight ErrorMsg guifg=#A31515')
end
config_colors()

function config_keymaps()
	local map = function(tbl)
		local opts = { noremap = true, silent = true }

		-- non-numerically indexed values goes into options
		for key, value in pairs(tbl) do
			if type(key) == 'string' then
				opts[key] = value
			end
		end

		vim.api.nvim_set_keymap(tbl[1], tbl[2], tbl[3], opts)
	end

	-- use \; to insert semicolon
	map {'n', '<leader>;', 'A;'}
	map {'i', '<leader>;', '<esc>A;'}

	-- use ; to start command where appropriate
	map {'n', ';', ':'}
	map {'v', ';', ':'}

    -- dismiss search matches by cr
    map {'n', '<cr>', ':noh<cr><cr>' }

    -- space-a to open diags list
    map {'n', '<space>a', ':Trouble<cr>'}

    -- code actions window by space-f
    map {'n', '<space>f', ':CodeActionMenu'}

    -- buffer management
    map {'n', ']b', ':BufferLineCycleNext<cr>'}
    map {'n', '[b', ':BufferLineCyclePrev<cr>'}
    map {'n', ']B', ':BufferLineMoveNext<cr>'}
    map {'n', '[B', ':BufferLineMovePrev<cr>'}
    map {'n', '<space>be', ':BufferLineSortByExtension<cr>'}
    map {'n', '<space>bd', ':BufferLineSortByDirectory<cr>'}

    -- fzf
    map {'n', '<space>d', ':DocumentSymbols<cr>'}
end
config_keymaps()

-- tabbar
function config_tabbar()
    require('bufferline').setup {
        options = {
            indicator_icon = ' ',
            buffer_close_icon = '',
            modified_icon = '●',
            close_icon = '',
            close_command = "bdelete %d",
            right_mouse_command = "bdelete! %d",
            left_trunc_marker = '',
            right_trunc_marker = '',
            show_tab_indicators = true,
            show_close_icon = false,
            -- disable icons
            show_buffer_icons = false,
            -- show diags
            diagnostics = "nvim_lsp",
        },
        highlights = {
            fill = {
                guifg = {attribute = "fg", highlight = "Normal"},
                guibg = {attribute = "bg", highlight = "StatusLineNC"},
            },
            background = {
                guifg = {attribute = "fg", highlight = "Normal"},
                guibg = {attribute = "bg", highlight = "StatusLine"}
            },
            buffer_visible = {
                gui = "",
                guifg = {attribute = "fg", highlight="Normal"},
                guibg = {attribute = "bg", highlight = "Normal"}
            },
            buffer_selected = {
                gui = "",
                guifg = {attribute = "fg", highlight="Normal"},
                guibg = {attribute = "bg", highlight = "Normal"}
            },
            separator = {
                guifg = {attribute = "bg", highlight = "Normal"},
                guibg = {attribute = "bg", highlight = "StatusLine"},
            },
            separator_selected = {
                guifg = {attribute = "fg", highlight="Special"},
                guibg = {attribute = "bg", highlight = "Normal"}
            },
            separator_visible = {
                guifg = {attribute = "fg", highlight = "Normal"},
                guibg = {attribute = "bg", highlight = "StatusLineNC"},
            },
            close_button = {
                guifg = {attribute = "fg", highlight = "Normal"},
                guibg = {attribute = "bg", highlight = "StatusLine"}
            },
            close_button_selected = {
                guifg = {attribute = "fg", highlight="normal"},
                guibg = {attribute = "bg", highlight = "normal"}
            },
            close_button_visible = {
                guifg = {attribute = "fg", highlight="normal"},
                guibg = {attribute = "bg", highlight = "normal"}
            },

        }
    }
end
config_tabbar()

-- status bar (with custom theme)
function lualine_vscode_light()
    local theme = require('lualine.themes.vscode')
    local black = '#111111'
    local white = '#eeeeee'
    local grey = '#dddddd'
    local green = '#B5CEA8'

    theme.normal.b.bg = grey
    theme.normal.c.bg = white
    theme.normal.c.fg = black

    theme.visual.a.fg = white
    theme.visual.b.bg = grey
    
    theme.insert.a.bg = green
    theme.insert.b.fg = black
    theme.insert.b.bg = grey
    theme.insert.c.bg = white
    theme.insert.c.fg = black

    return theme
end
require('lualine').setup {
    options = {
        icons_enabled = false,
        component_separators = '',
        section_separators = '',
        theme = lualine_vscode_light(),
    },
}

-- auto close brackets
require('nvim-autopairs').setup{}

-- syntax highlights
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
    }
}

require('surround').setup {
    mappings_style = 'surround',
    prefix = 'S',
}

function config_cmp()
    -- Setup nvim-cmp.
    local cmp = require('cmp')

    cmp.setup({
      snippet = {
        expand = function(args)
          -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
        end,
      },
      mapping = {
        ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable,
        ['<C-e>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'luasnip' },
        { name = 'path' },
      },
    })
end
config_cmp()

-- auto format on save
function config_format()
    vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting()]]
end
config_format()

-- signature helper
require "lsp_signature".setup {
    -- replace the panda emoji (why panda, why???)
    hint_prefix = "♢ ",
    -- remove borders
    handler_opts = {
        border = "none",
    },
}

-- diagnostics
function config_diag()
    -- hide virtual text diagnostics
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            -- disable diagnostics virtual text
            virtual_text = false,
            signs = true,
            update_in_insert = false,
        }
    )
    -- show diag float on hover
    vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false})]]
    require('trouble').setup {
        icons = false,
    }
end
config_diag()

function config_lsp()
    -- LSP
    local nvim_lsp = require('lspconfig')
    
    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    
        -- Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
    
        -- Mappings.
        local opts = { noremap=true, silent=true }
    
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    end
    
    local lsp = require "lspconfig"
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

    
    local servers = { 'pyright', 'rust_analyzer', 'clangd' }
    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
            on_attach = on_attach,
            flags = {
                debounce_text_changes = 150,
            },
            capabilities = capabilities,
        }
    end
end
config_lsp()
