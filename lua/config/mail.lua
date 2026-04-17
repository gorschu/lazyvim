-- Mail compose settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "mail",
  callback = function()
    local tw = 72
    vim.opt_local.textwidth = tw
    vim.opt_local.formatoptions:append("w") -- format-flowed (trailing space = paragraph continues)
    vim.opt_local.formatoptions:remove("a") -- no auto-reflow, it mangles flowed paragraphs
    vim.opt_local.formatexpr = ""
    vim.opt_local.formatprg = "par w" .. tw .. "q"
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en,de"
  end,
})

-- Jump past headers to body when composing
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "/tmp/neomutt-*",
  callback = function()
    vim.fn.search("^$") -- find first blank line (end of headers)
    vim.cmd("normal! j") -- move to first line of body
  end,
})
