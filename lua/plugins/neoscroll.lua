return {
  "karb94/neoscroll.nvim",
  opts = {
    post_hook = function(info)
      if info == "center" then
        vim.cmd("normal! zz")
      end
    end,
  },
}
