" === 基础设置 ===
set number                       " 显示行号
set relativenumber               " 相对行号
set tabstop=4                    " 制表符宽度
set shiftwidth=4                 " 自动缩进宽度
set expandtab                    " 使用空格替代 Tab
set mouse=a                      " 启用鼠标支持
set termguicolors                " 启用 24 位颜色支持
set clipboard=unnamedplus        " 系统剪贴板同步

" === 插件管理器配置 ===
lua << EOF
require('packer').startup(function(use)
    -- Packer 管理自身
    use 'wbthomason/packer.nvim'

    -- LSP 和 Rust 开发支持
    use 'neovim/nvim-lspconfig'          -- Neovim LSP 配置
    use 'simrat39/rust-tools.nvim'       -- Rust 工具集成

    -- 自动补全和代码片段
    use 'hrsh7th/nvim-cmp'               -- 主补全插件
    use 'hrsh7th/cmp-nvim-lsp'           -- LSP 补全源
    use 'hrsh7th/cmp-buffer'             -- 缓冲区补全源
    use 'hrsh7th/cmp-path'               -- 路径补全源
    use 'L3MON4D3/LuaSnip'               -- 代码片段引擎

    -- 目录树插件
    use {
        'nvim-tree/nvim-tree.lua',
        requires = 'nvim-tree/nvim-web-devicons' -- 文件图标支持
    }

    -- 状态栏
    use 'nvim-lualine/lualine.nvim'

    -- 主题（可选）
    use 'gruvbox-community/gruvbox'
end)
EOF

" === 配置 LSP 和 Rust Tools ===
lua << EOF
local nvim_lsp = require('lspconfig')
local rust_tools = require('rust-tools')

-- 配置 rust-analyzer
rust_tools.setup({
    server = {
        on_attach = function(_, bufnr)
            -- LSP 快捷键绑定
            local bufopts = { noremap=true, silent=true, buffer=bufnr }
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
        end,
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy"  -- 使用 Clippy 检查代码
                },
                diagnostics = {
                    disabled = { "unresolved-proc-macro" }  -- 禁用耗资源诊断
                }
            }
        }
    },
    tools = {
        inlay_hints = {
            only_current_line = true,  -- 避免全局提示导致卡顿
            show_parameter_hints = true,
        }
    }
})
EOF

" === 自动补全配置 ===
lua << EOF
local cmp = require('cmp')
cmp.setup({
    mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
    }
})
EOF

" === 目录树配置 ===
lua << EOF
require("nvim-tree").setup({
    view = {
        width = 30,
        side = "left",
    },
    git = {
        enable = true,
    },
    diagnostics = {
        enable = true,
    },
})
EOF

" 快捷键绑定
nnoremap <C-n> :NvimTreeToggle<CR>  " Ctrl+n 打开/关闭目录树

" === 状态栏配置 ===
lua << EOF
require('lualine').setup({
    options = {
        theme = 'gruvbox',
        icons_enabled = true,
    }
})
EOF

" === 主题设置（可选） ===
colorscheme gruvbox
