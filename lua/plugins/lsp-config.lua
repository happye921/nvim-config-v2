return {
  "neovim/nvim-lspconfig",

  dependencies = {
    "stevearc/conform.nvim",

    -- Modern repository names
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",

    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",

    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",

    "j-hui/fidget.nvim",
  },

  config = function()
    ---------------------------------------------------------------------------
    -- Formatting
    ---------------------------------------------------------------------------

    require("conform").setup({
      formatters_by_ft = {
        -- Add external formatters here when needed.
        --
        -- lua = { "stylua" },
        -- cpp = { "clang_format" },
        -- c = { "clang_format" },
      },
    })

    ---------------------------------------------------------------------------
    -- Completion capabilities
    ---------------------------------------------------------------------------

    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")

    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

    -- Apply nvim-cmp capabilities to every LSP configuration.
    --
    -- Server-specific configurations below are merged on top of this.
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    ---------------------------------------------------------------------------
    -- Server-specific LSP configuration
    ---------------------------------------------------------------------------

    vim.lsp.config("clangd", {
      cmd = {
        "clangd",
        "--header-insertion=never",
      },
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },

          diagnostics = {
            globals = {
              "vim",
            },
          },

          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },

          format = {
            enable = true,
            defaultConfig = {
              indent_style = "space",
              indent_size = "2",
            },
          },
        },
      },
    })

    vim.lsp.config("tailwindcss", {
      filetypes = {
        "html",
        "css",
        "scss",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
        "heex",
      },
    })

    vim.lsp.config("zls", {
      root_markers = {
        "zls.json",
        "build.zig",
        ".git",
      },

      settings = {
        zls = {
          enable_inlay_hints = true,
          enable_snippets = true,
          warn_style = true,
        },
      },
    })

    vim.g.zig_fmt_parse_errors = 0
    vim.g.zig_fmt_autosave = 0

    ---------------------------------------------------------------------------
    -- Godot GDScript LSP
    ---------------------------------------------------------------------------

    -- Godot runs its own language server on port 6005.
    -- This is not installed or managed by Mason.
    vim.lsp.config("gdscript", {
      cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),

      root_markers = {
        "project.godot",
        ".git",
      },
    })

    -- Since GDScript is not managed by Mason, enable it manually.
    vim.lsp.enable("gdscript")

    ---------------------------------------------------------------------------
    -- Mason
    ---------------------------------------------------------------------------

    require("mason").setup()

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "vtsls",
        "tailwindcss",
        "clangd",
        "zls",
        "slangd",
      },

      -- This is true by default, but leaving it explicit makes the behavior
      -- clear: Mason automatically enables every installed server above.
      automatic_enable = true,
    })

    ---------------------------------------------------------------------------
    -- LSP status UI
    ---------------------------------------------------------------------------

    require("fidget").setup({})

    ---------------------------------------------------------------------------
    -- Completion
    ---------------------------------------------------------------------------

    local cmp_select = {
      behavior = cmp.SelectBehavior.Select,
    }

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<Tab>"] = cmp.mapping.confirm({
          select = true,
        }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),

      sources = cmp.config.sources({
        {
          name = "copilot",
          group_index = 2,
        },
        {
          name = "nvim_lsp",
        },
        {
          name = "luasnip",
        },
        {
          name = "path",
        },
      }, {
        {
          name = "buffer",
        },
      }),
    })

    ---------------------------------------------------------------------------
    -- Command-line completion
    ---------------------------------------------------------------------------

    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),

      sources = {
        {
          name = "buffer",
        },
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),

      sources = cmp.config.sources({
        {
          name = "path",
        },
      }, {
        {
          name = "cmdline",
        },
      }),
    })

    ---------------------------------------------------------------------------
    -- Diagnostics
    ---------------------------------------------------------------------------

    vim.diagnostic.config({
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
    })
  end,
}
