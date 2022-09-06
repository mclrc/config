" Specify a directory for plugins
call plug#begin('~/.vim/plugged')
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
Plug 'neoclide/coc.nvim'
Plug 'jiangmiao/auto-pairs'
Plug 'machakann/vim-sandwich'
" Plug 'tpope/vim-sleuth'
Plug 'editorconfig/editorconfig-vim'
Plug 'airblade/vim-gitgutter'
Plug 'morhetz/gruvbox'
Plug 'sonph/onehalf'
" fuzzy find files
Plug 'ctrlpvim/ctrlp.vim'

" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'
Plug 'Chiel92/vim-autoformat'

" Rust-specific plugins
" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'
" Completion framework
Plug 'hrsh7th/nvim-cmp'
" LSP completion source for nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'
" Snippet completion source for nvim-cmp
Plug 'hrsh7th/cmp-vsnip'
" Other usefull completion sources
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'arcticicestudio/nord-vim'
" See hrsh7th's other plugins for more completion sources!
" To enable more of the features of rust-analyzer, such as inlay hints and more!
Plug 'simrat39/rust-tools.nvim'
" Snippet engine
Plug 'hrsh7th/vim-vsnip'

" Color schemes
Plug 'itchyny/lightline.vim'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'dracula/vim', {'as': 'dracula'}

Plug 'neoclide/coc-vetur'
Plug 'tpope/vim-surround'

" Plug 'lukas-reineke/indent-blankline.nvim'

" Python stuff
Plug 'python-mode/python-mode', {'for': 'python', 'branch': 'develop'}

" File tree
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

" Emmet for html
Plug 'mattn/emmet-vim'

" CSS color previews
Plug 'ap/vim-css-color'

" Leetcode in nvim
Plug 'ianding1/leetcode.vim'
call plug#end()

if $TERM == "xterm-256color"
  set t_Co=256
endif
set termguicolors
set fillchars=vert:\ 

let g:lightline = {'colorscheme': 'one'}
" Available flavours: latte, frappe, macchiato, mocha, dusk
let g:catppuccin_flavour = "macchiato"
colorscheme catppuccin

set tabstop=2
set shiftwidth=2
set relativenumber
set signcolumn=yes
set number
inoremap < <
inoremap > >
set smartindent
set clipboard+=unnamedplus

" Ctrl+p file search
map <C-p> :CtrlP
inoremap <silent><expr> <c-space> coc#refresh()

" File tree config
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

" Emmet config
" let g:user_emmet_leader_key='<C-left>'

" Leetcode binds
nnoremap <leader>ml :LeetCodeList<cr>
nnoremap <leader>mt :LeetCodeTest<cr>
nnoremap <leader>ms :LeetCodeSubmit<cr>
nnoremap <leader>mi :LeetCodeSignIn<cr>
let g:leetcode_browser = 'chrome'
let g:leetcode_solution_filetype = 'rust'
let g:leetcode_hide_paid_only = 1

autocmd BufWritePre *.rs :Autoformat
let g:rust_recommended_style = 0

autocmd BufWritePre *.py :PymodeLintAuto
let g:python3_host_prog = '/usr/bin/python3'

" Press ctrl+(h|j|k|l) to either switch to or create a new pane in that
" direction
function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction

nnoremap <silent> <C-h> :call WinMove('h')<CR>
nnoremap <silent> <C-j> :call WinMove('j')<CR>
nnoremap <silent> <C-k> :call WinMove('k')<CR>
nnoremap <silent> <C-l> :call WinMove('l')<CR>

lua <<EOF
require'nvim-tree'.setup {
}
EOF

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
lua <<EOF
local nvim_lsp = require'lspconfig'

local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

require('rust-tools').setup(opts)
EOF

" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})
EOF

