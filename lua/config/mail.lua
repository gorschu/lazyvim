-- Mail compose settings
local group = vim.api.nvim_create_augroup("user_mail", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
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

-- Jump past headers once when opening a draft, including under a custom TMPDIR.
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = group,
  pattern = "*/neomutt-*",
  callback = function(args)
    -- The pattern's * also matches /, so require a draft filename, not a neomutt-* directory.
    if not vim.fs.basename(args.file):match("^neomutt%-") or vim.b[args.buf].mail_body_positioned then
      return
    end
    local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
    for line_number, line in ipairs(lines) do
      if line == "" then
        vim.api.nvim_win_set_cursor(0, { math.min(line_number + 1, #lines), 0 })
        vim.b[args.buf].mail_body_positioned = true
        break
      end
    end
  end,
})
