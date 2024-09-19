" 显示行号
set number

" 显示相对行号
" set relativenumber


call plug#begin('~/.local/share/nvim/plugged')

" Neovim LSP 支持
Plug 'neovim/nvim-lspconfig'

" 颜色
Plug 'joshdick/onedark.vim'

" 自动补全引擎
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons'


" 代码高亮和代码解析（Treesitter）
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Rust 支持
Plug 'simrat39/rust-tools.nvim'

" Python 支持
Plug 'psf/black' " Python 格式化工具

" 文件搜索
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

" 启用 Treesitter 进行语法高亮
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"c", "rust", "python"},  -- 根据需要增加语言支持
  highlight = { enable = true },
}
EOF

" 设置补全
lua <<EOF
  local cmp = require'cmp'
  cmp.setup {
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
      ['<Tab>'] = cmp.mapping.select_next_item(),
      ['<S-Tab>'] = cmp.mapping.select_prev_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
      { name = 'buffer' },
    }
  }
EOF

" 启用 LSP
lua <<EOF
require'lspconfig'.clangd.setup{}      -- C/C++ LSP
require'lspconfig'.rust_analyzer.setup{}  -- Rust LSP
require'lspconfig'.pyright.setup{}     -- Python LSP
EOF

augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.py execute ':Black'
augroup END

nnoremap <C-p> :Files<CR>
nnoremap <C-n> :NvimTreeToggle<CR>

colorscheme onedark

lua require'nvim-tree'.setup {}

