vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable", -- latest stable release
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("vim-options")

-- Neovim does not ship filetype detection for the common HLSL extensions.
-- `slangd` attaches to the `hlsl` filetype, so define it before files open.
vim.filetype.add({
  extension = {
    hlsl = "hlsl",
    hlsli = "hlsl",
    fx = "hlsl",
    fxi = "hlsl",
  },
})

require("lazy").setup({
  spec = "plugins",
  change_detection = { notify = false }
})

vim.cmd([[
  hi Normal guibg=NONE ctermbg=NONE
  hi NonText guibg=NONE ctermbg=NONE
]])

local autocmd = vim.api.nvim_create_autocmd

autocmd('LspAttach', {
  callback = function(e)
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  end
})

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
-- Center after the animation finishes, preserving the original <C-d>zz / <C-u>zz behavior.
vim.keymap.set("n", "<C-d>", function()
  require("neoscroll").ctrl_d({ duration = 250, info = "center" })
end)
vim.keymap.set("n", "<C-u>", function()
  require("neoscroll").ctrl_u({ duration = 250, info = "center" })
end)
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "<C-s>", function()
  -- format buffer (async)
  vim.lsp.buf.format()

  -- save file
  vim.cmd("update")
end, { silent = true })

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'svelte' },
  callback = function() vim.treesitter.start() end,
})

vim.api.nvim_create_user_command("GodotOpen", function(args)
  if #args.fargs ~= 3 then
    vim.notify("GodotOpen expects: file line column", vim.log.levels.ERROR)
    return
  end

  local file = args.fargs[1]
  local line = tonumber(args.fargs[2]) or 1
  local column = tonumber(args.fargs[3]) or 1

  vim.cmd("drop " .. vim.fn.fnameescape(file))

  vim.api.nvim_win_set_cursor(0, {
    math.max(line - 1, 0),
    math.max(column - 1, 0),
  })
end, {
  nargs = "+",
  complete = "file",
})
