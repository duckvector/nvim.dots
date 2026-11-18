-- init.lua

-------------------------------------------------------------------------------
-- 1. Leader Keys & Core Options
-------------------------------------------------------------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.clipboard = "unnamedplus"
opt.showmode = false

vim.filetype.add({
    extension = {
        asm = "asm",
        inc = "asm",
        fasm = "fasm",
        s = "asm",
        S = "asm",
    },
})

-------------------------------------------------------------------------------
-- 2. Keymaps
-------------------------------------------------------------------------------

local keymap = vim.keymap.set

keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")
keymap("n", "<leader>q", "<cmd>qa<CR>")
keymap("n", "<leader>qw", "<cmd>wqa<CR>")

keymap("n", "<S-h>", "<cmd>bprevious<CR>")
keymap("n", "<S-l>", "<cmd>bnext<CR>")

keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

-- Run just if available, otherwise make.
keymap("n", "<F5>", function()
    if vim.fn.executable("just") == 1 then
        vim.cmd("!just")
    elseif vim.fn.executable("make") == 1 then
        vim.cmd("!make")
    else
        vim.notify("Neither just nor make was found", vim.log.levels.WARN)
    end
end, { desc = "Build project" })

-------------------------------------------------------------------------------
-- 3. Native Plugin Manager (Neovim 0.12+)
-------------------------------------------------------------------------------

vim.pack.add({
    -- Theme
    { src = "https://github.com/EdenEast/nightfox.nvim" },

    -- General
    { src = "https://github.com/okuuva/auto-save.nvim" },
    { src = "https://github.com/famiu/bufdelete.nvim" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },

    -- Terminal / Hex
    { src = "https://github.com/akinsho/toggleterm.nvim" },
    { src = "https://github.com/RaafatTurki/hex.nvim" },

    -- UI
    { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
    { src = "https://github.com/sphamba/smear-cursor.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },

    -- Mini
    { src = "https://github.com/echasnovski/mini.nvim" },

    -- Treesitter
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },

    -- LSP
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
})

-------------------------------------------------------------------------------
-- 4. Theme: Carbonfox (Deep Black)
-------------------------------------------------------------------------------

require("nightfox").setup({
    options = {
        styles = {
            comments = "italic",
            keywords = "NONE",
        },
    },
})

vim.cmd.colorscheme("carbonfox")

-- Extra dark backgrounds
local bg = "#090a0e"
local accent = "#82aaff"

vim.api.nvim_set_hl(0, "Normal", { bg = bg })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#101116" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = accent, bg = "#101116" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#101116" })
vim.api.nvim_set_hl(0, "PmenuSel", {
    bg = "#292d3e",
    fg = accent,
    bold = true,
})
vim.api.nvim_set_hl(0, "SignColumn", { bg = bg })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#14151b" })

-------------------------------------------------------------------------------
-- 5. Auto Save
-------------------------------------------------------------------------------

require("auto-save").setup({
    enabled = true,

    trigger_events = {
        immediate_save = { "FocusLost", "BufLeave" },
        defer_save = { "InsertLeave", "TextChanged" },
    },

    write_all_buffers = false,
    debounce_delay = 1000,
})

-------------------------------------------------------------------------------
-- 6. Buffer Delete
-------------------------------------------------------------------------------

keymap("n", "<leader>bd", "<cmd>Bdelete<CR>",
    { desc = "Close Buffer (Keep Splits)" })

keymap("n", "<leader>bD", "<cmd>Bdelete!<CR>",
    { desc = "Force Close Buffer" })

-------------------------------------------------------------------------------
-- 7. Which-Key
-------------------------------------------------------------------------------

require("which-key").setup({
    preset = "modern",
    win = {
        border = "rounded",
    },
})

-------------------------------------------------------------------------------
-- 8. Git Signs
-------------------------------------------------------------------------------

require("gitsigns").setup({})

-------------------------------------------------------------------------------
-- 9. ToggleTerm
-------------------------------------------------------------------------------

require("toggleterm").setup({
    open_mapping = [[<C-\>]],
    direction = "float",
    float_opts = {
        border = "rounded",
    },
})

keymap("n", "<leader>x", "<cmd>ToggleTerm<CR>",
    { desc = "Toggle Terminal" })

-------------------------------------------------------------------------------
-- 10. Hex Editor
-------------------------------------------------------------------------------

keymap("n", "<leader>hx", "<cmd>HexToggle<CR>",
    { desc = "Toggle Hex View" })

-------------------------------------------------------------------------------
-- 11. Indent Blankline
-------------------------------------------------------------------------------

require("ibl").setup({})

-------------------------------------------------------------------------------
-- 12. Smear Cursor
-------------------------------------------------------------------------------

require("smear_cursor").setup({
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    stiffness = 0.8,
    trailing_stiffness = 0.5,
    distance_stop_animating = 0.5,
})

-------------------------------------------------------------------------------
-- 13. Lualine
-------------------------------------------------------------------------------

require("lualine").setup({
    options = {
        theme = "auto",
        component_separators = "",
        section_separators = "",
        globalstatus = true,
    },

    sections = {
        lualine_a = {
            {
                "mode",
                fmt = function(str)
                    return str:sub(1, 1)
                end,
            },
        },

        lualine_b = {
            {
                "diagnostics",
                symbols = {
                    error = "E ",
                    warn = "W ",
                    info = "I ",
                    hint = "H ",
                },
            },

            {
                "filetype",
                colored = false,
            },

            {
                "filename",
                path = 0,
                symbols = {
                    modified = " [+]",
                    readonly = " [RO]",
                    unnamed = "[No Name]",
                },
            },
        },

        lualine_c = {},
        lualine_x = { "encoding", "fileformat" },
        lualine_y = {},
        lualine_z = { "location" },
    },
})

-------------------------------------------------------------------------------
-- 14. Mini.nvim
-------------------------------------------------------------------------------

-- Mini Starter
local starter = require("mini.starter")

starter.setup({
    header = table.concat({
        "  ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
        "  ████╗  ██║██║   ██║██║████╗ ████║",
        "  ██╔██╗ ██║██║   ██║██║██╔████╔██║",
        "  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "  ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "  ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "  [       HAPPY HACKING           ]",
    }, "\n"),

    items = {
        starter.sections.recent_files(5, false),
        { name = "New File", action = "enew", section = "Actions" },
        { name = "Quit Neovim", action = "qa", section = "Actions" },
    },

    content_hooks = {
        starter.gen_hook.adding_bullet(" > "),
        starter.gen_hook.aligning("center", "center"),
    },

    footer = "",
})

-- Mini Files
require("mini.files").setup()

keymap("n", "<leader>e", function()
    if not MiniFiles.close() then
        MiniFiles.open()
    end
end, { desc = "Toggle Mini Files" })

-- Mini Pick
require("mini.pick").setup()

keymap("n", "<leader>ff", "<cmd>Pick files<CR>",
    { desc = "Find Files" })
keymap("n", "<leader>fg", "<cmd>Pick grep_live<CR>",
    { desc = "Grep Text" })
keymap("n", "<leader>fb", "<cmd>Pick buffers<CR>",
    { desc = "Find Buffers" })

-- Mini Tabline
require("mini.tabline").setup({
    show_icons = true,
})

-- Mini Pairs and Comment
require("mini.pairs").setup()
require("mini.comment").setup()

-- Mini Completion
require("mini.completion").setup({
    lsp_completion = {
        source_func = "completefunc",
        auto_setup = true,
    },

    window = {
        info = { border = "rounded" },
        signature = { border = "rounded" },
    },
})

keymap("i", "<Tab>", 'pumvisible() ? "\\<C-n>" : "\\<Tab>"',
    { expr = true })
keymap("i", "<S-Tab>", 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"',
    { expr = true })

-------------------------------------------------------------------------------
-- 15. Treesitter (Neovim 0.12 API)
-------------------------------------------------------------------------------

require("nvim-treesitter").setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
})

local parsers = {
    "c",
    "cpp",
    "asm",
    "make",
    "cmake",
    "lua",
    "vim",
}

require("nvim-treesitter").install(parsers)

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "c",
        "cpp",
        "asm",
        "make",
        "cmake",
        "lua",
        "vim",
    },

    callback = function()
        pcall(vim.treesitter.start)
    end,
})

-------------------------------------------------------------------------------
-- 16. Mason
-------------------------------------------------------------------------------

require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = { "clangd" },
    automatic_enable = false,
})

-------------------------------------------------------------------------------
-- 17. LSP Configuration (Neovim 0.11+)
-------------------------------------------------------------------------------

-- Diagnostic appearance
vim.diagnostic.config({
    virtual_text = {
        spacing = 4,
        prefix = "●",
    },

    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,

    float = {
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
    },
})

-- LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local opts = {
            buffer = args.buf,
            silent = true,
        }

        keymap("n", "gd", vim.lsp.buf.definition,
            vim.tbl_extend("force", opts, {
                desc = "Go to Definition",
            }))

        keymap("n", "gr", vim.lsp.buf.references,
            vim.tbl_extend("force", opts, {
                desc = "Find References",
            }))

        keymap("n", "K", function()
            vim.lsp.buf.hover({
                border = "rounded",
            })
        end, vim.tbl_extend("force", opts, {
            desc = "Hover Documentation",
        }))

        keymap("n", "<leader>rn", vim.lsp.buf.rename,
            vim.tbl_extend("force", opts, {
                desc = "Rename Symbol",
            }))

        keymap("n", "<leader>ca", vim.lsp.buf.code_action,
            vim.tbl_extend("force", opts, {
                desc = "Code Action",
            }))

        keymap("n", "[d", vim.diagnostic.goto_prev,
            vim.tbl_extend("force", opts, {
                desc = "Previous Diagnostic",
            }))

        keymap("n", "]d", vim.diagnostic.goto_next,
            vim.tbl_extend("force", opts, {
                desc = "Next Diagnostic",
            }))

        keymap("n", "<leader>d", vim.diagnostic.open_float,
            vim.tbl_extend("force", opts, {
                desc = "Show Diagnostic",
            }))

        keymap("i", "<C-k>", function()
            vim.lsp.buf.signature_help({
                border = "rounded",
            })
        end, vim.tbl_extend("force", opts, {
            desc = "Signature Help",
        }))
    end,
})

-- Clangd configuration
vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
    },

    capabilities = vim.lsp.protocol.make_client_capabilities(),
})

-- Enable clangd
vim.lsp.enable("clangd")

-------------------------------------------------------------------------------
-- 18. Plugin Manager Commands
-------------------------------------------------------------------------------

-- Update installed plugins:
-- :lua vim.pack.update()

-- View plugin status:
-- :lua vim.pack.get()

-- Check LSP:
-- :checkhealth vim.lsp

-- Check Treesitter:
-- :checkhealth nvim-treesitter

