-- ~/.config/nvim/init.lua

-------------------------------------------------------------------------------
-- 1. Leader Keys & Core Options
-------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- Line Numbers
opt.number = true
opt.relativenumber = true

-- Indentation & Tabs (4 spaces for C and Assembly)
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

-- UI Settings
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.clipboard = "unnamedplus"
opt.showmode = false -- Hide -- INSERT -- under statusline

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

-- Clear search highlights
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear Search Highlights" })

-- Quick Exits
keymap("n", "<leader>q", "<cmd>qa<CR>", { desc = "Quit All / Exit Neovim" })
keymap("n", "<leader>qw", "<cmd>wqall<CR>", { desc = "Save All & Quit" })

-- Buffer/Tab Bar Navigation (Top Horizontal Bar)
keymap("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Go to Left Buffer" })
keymap("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Go to Right Buffer" })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Quick compile / just or make (<F5>)
keymap("n", "<F5>", function()
    vim.cmd("!just")
    vim.cmd("!make")
    vim.cmd("")
end, { desc = "run just and make hoping one of them works" })

-------------------------------------------------------------------------------
-- 3. Lazy.nvim Bootstrap
-------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-------------------------------------------------------------------------------
-- 4. Plugin Setup
-------------------------------------------------------------------------------
require("lazy").setup({

  -- Theme: TokyoNight (Night Variant)
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = false },
        },
      })
      vim.cmd("colorscheme tokyonight")

      -- Unified borders matching which-key popup styling
      local border_color = "#7aa2f7"
      local bg_color = "#1f2335"

      vim.api.nvim_set_hl(0, "FloatBorder", { fg = border_color, bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg_color })
      vim.api.nvim_set_hl(0, "Pmenu", { bg = bg_color, fg = "#c0caf5" })
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#3b4261", fg = border_color, bold = true })
      vim.api.nvim_set_hl(0, "PmenuBorder", { fg = border_color, bg = bg_color })
      vim.api.nvim_set_hl(0, "PmenuSbar", { bg = bg_color })
      vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#3b4261" })
    end,
  },

  -- Auto Save (Actively maintained fork)
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      trigger_events = {
        immediate_save = { "FocusLost", "BufLeave" },
        defer_save = { "InsertLeave", "TextChanged" },
      },
      condition = function(buf)
        local fn = vim.fn
        if fn.getbufvar(buf, "&modifiable") == 1 and
           fn.getbufvar(buf, "&filetype") ~= "gitcommit" then
          return true
        end
        return false
      end,
      write_all_buffers = false,
      debounce_delay = 1000,
    },
  },

  -- Smart Buffer Delete (preserves split layout)
  {
    "famiu/bufdelete.nvim",
    keys = {
      { "<leader>bd", "<cmd>Bdelete<CR>", desc = "Close Buffer (Keep Splits)" },
      { "<leader>bD", "<cmd>Bdelete!<CR>", desc = "Force Close Buffer" },
    },
  },

  -- Which-Key Menu
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      win = { border = "rounded" },
    },
  },

  -- Git Signs
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },

  -- Floating Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = [[<C-\>]],
      direction = "float",
      float_opts = { border = "" },
    },
    keys = {
            { "<leader>x", "<cmd>ToggleTerm<CR>", desc= "Toggles Terminal"}
    },
  },

  -- Hex Editor Toggle
  {
    "RaafatTurki/hex.nvim",
    cmd = { "HexToggle", "HexDump", "HexAssemble" },
    opts = {},
    keys = {
      { "<leader>hx", "<cmd>HexToggle<CR>", desc = "Toggle Hex View" },
    },
  },

  -- Indent Blankline Guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },

  -- Smear Cursor []
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.5,
    },
  },
    {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
     -- Mini.nvim
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      -- Mini.starter Dashboard
      local starter = require("mini.starter")
      starter.setup({
        header = table.concat({
          "  ███╗   ██╗██╗   ██╗██╗███╗   ███╗  ",
          "  ████╗  ██║██║   ██║██║████╗ ████║  ",
          "  ██╔██╗ ██║██║   ██║██║██╔████╔██║  ",
          "  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║  ",
          "  ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║  ",
          "  ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝  ",
          "  [    INSERT A COOL TEXT HERE    ]  ",
        }, "\n"),
        items = {
          starter.sections.recent_files(5, false),
          -- { name = "Find File", action = "Pick files", section = "Navigate" },
          -- { name = "Live Grep", action = "Pick grep_live", section = "Navigate" },
          { name = "New File", action = "enew", section = "Actions" },
          { name = "Quit Neovim", action = "qa", section = "Actions" },
        },
        content_hooks = {
          starter.gen_hook.adding_bullet(" > "),
          starter.gen_hook.aligning("center", "center"),
        },
            footer = "",
      })

      -- Mini.files
      require("mini.files").setup()
      vim.keymap.set("n", "<leader>e", function()
        if not MiniFiles.close() then MiniFiles.open() end
      end, { desc = "Toggle Mini Files" })

      -- Mini.pick
      require("mini.pick").setup()
      vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<CR>", { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", "<cmd>Pick grep_live<CR>", { desc = "Grep Text" })
      vim.keymap.set("n", "<leader>fb", "<cmd>Pick buffers<CR>", { desc = "Find Buffers" })

      -- Mini.tabline (Horizontal Tab/Buffer Bar at Top)
      require("mini.tabline").setup({ show_icons = true })

      -- Mini.statusline, Mini.pairs, Mini.comment
      -- require("mini.statusline").setup({ 
      --           content = {
      --               active = nil,
      --               inactive = nil,
      --           },
      --           use_icons = true })
      require("mini.pairs").setup()
      require("mini.comment").setup()

      -- Mini.completion
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

      vim.keymap.set("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
      vim.keymap.set("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
    end,
  },

  -- Treesitter Syntax Highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()

    end,
  },

      -- LSP Management (Neovim 0.11+)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd" },
      })

      -- Updated rounded border setup without vim.lsp.with()
      vim.diagnostic.config({ float = { border = "rounded" } })
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with_override or function(err, result, ctx, config)
        config = config or {}
        config.border = "rounded"
        return vim.lsp.handlers.hover(err, result, ctx, config)
      end

      -- Modern handler configuration for hover and signature help
      vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
        return vim.lsp.handlers.hover(err, result, ctx, vim.tbl_extend("force", config or {}, { border = "rounded" }))
      end
      vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
        return vim.lsp.handlers.signature_help(err, result, ctx, vim.tbl_extend("force", config or {}, { border = "rounded" }))
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf, silent = true }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to Definition" }))
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover Documentation" }))
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous Diagnostic" }))
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next Diagnostic" }))
        end,
      })

      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
      })

      vim.lsp.enable("clangd")
    end,
  },
}, {
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },

})

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
          warn  = "W ",
          info  = "I ",
          hint  = "H ",
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

    lualine_x = {
      "encoding",
      "fileformat",
    },

    lualine_y = {},

    lualine_z = {
      "location",
   },
  },
})

      require("nvim-treesitter.config").setup({
        ensure_installed = { "c", "cpp", "asm", "make", "cmake", "lua", "vim" },
        highlight = { enable = true },
        indent = { enable = true },
      })
