set number
" 使用 packer.nvim 作为插件管理器
packadd packer.nvim

" packer 配置
lua << EOF
require('packer').startup(function(use)
  -- Packer 自己管理自己
  use 'wbthomason/packer.nvim'

  -- LSP 配置
  use 'neovim/nvim-lspconfig'

  -- 补全插件
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'

  -- 额外的补全源（如snippet）
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  -- 语法高亮
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- 添加目录树插件及其依赖
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- 可选，文件图标
    },
  }
end)

-- 配置 LSP 服务器
local lspconfig = require('lspconfig')

-- Rust
lspconfig.rust_analyzer.setup{}

-- C
lspconfig.clangd.setup{}

-- Python
-- 使用 pylsp
lspconfig.pylsp.setup{}
-- 或者使用 pyright
-- lspconfig.pyright.setup{}

-- JavaScript/TypeScript
lspconfig.ts_ls.setup{}

-- 补全设置
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- 语法高亮
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "rust", "c", "python", "javascript" },
  highlight = {
    enable = true,
  },
}

-- 自动保存时格式化代码（可选）
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- 目录树配置
require("nvim-tree").setup({
  sort_by = "name", -- 按文件名排序
  view = {
    width = 30,
    side = "left", -- 在左侧显示
  },
  renderer = {
    add_trailing = false,
    highlight_git = true,
    group_empty = true,
  },
  filters = {
    dotfiles = false, -- 不显示隐藏文件
  },
  on_attach = function(bufnr)
    local api = require('nvim-tree.api')
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- 定义快捷键
    vim.keymap.set('n', '<CR>', api.node.open.edit, opts)           -- 回车打开文件
    vim.keymap.set('n', '<C-e>', api.tree.close, opts)             -- Ctrl + e 关闭树
    vim.keymap.set('n', '<C-r>', api.tree.reload, opts)            -- Ctrl + r 刷新树
    vim.keymap.set('n', 'a', api.fs.create, opts)                  -- 创建文件/文件夹
    vim.keymap.set('n', 'd', api.fs.remove, opts)                  -- 删除文件/文件夹
    vim.keymap.set('n', 'r', api.fs.rename, opts)                  -- 重命名
    vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts) -- 上一级目录
  end,
})

-- 快捷键设置
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- 自动打开目录树（当启动时没有打开任何文件时）
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      require("nvim-tree.api").tree.open()
    end
  end
})

EOF

nnoremap <leader>a :!google-chrome-stable<CR>
