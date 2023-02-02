local function parse_args(fargs)
  local args = {}
  local opts = {}
  for _, arg in ipairs(fargs) do
    if arg:match('^%-%-') then
      local key, val = arg:match('^%-%-(%S+)=(.*)')
      opts[key] = val
    else
      table.insert(args, vim.fn.expand(arg))
    end
  end
  return args, opts
end

local function get_viewers()
  local viewers = {
    'firefox',
    'google-chrome',
    'google-chrome-beta',
    'google-chrome-dev',
    'google-chrome-stable',
    'okular',
    'zathura',
  }
  local idx = 1
  while idx <= #viewers do
    local viewer = viewers[idx]
    if vim.fn.executable(viewer) == 0 then
      table.remove(viewers, idx)
    else
      idx = idx + 1
    end
  end
  return viewers
end

local function get_md_files()
  local bufnames = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':~:.')
    if bufname:match('.md$') then
      table.insert(bufnames, bufname)
    end
  end
  return bufnames
end

local function complete_md_to_pdf(arg_before, cmdline, cursor_pos)
  if arg_before == '' then
    return get_md_files()
  elseif arg_before == '--' then
    return {
      '--viewer',
      '--pdf-engine',
    }
  elseif arg_before == '--viewer=' then
    return get_viewers()
  elseif arg_before == '--pdf-engine=' then
    return {
      'latexmk',
      'lualatex',
      'pdflatex',
      'wkhtmltopdf',
      'xelatex',
    }
  end
  return {}
end

local function close_handler(handler)
  if handler and not handler:is_closing() then
    handler:close()
  end
end

local function spawn_viewer(args, opts)
  local fname_pdfs = {}
  for _, fname in ipairs(args) do
    local fname_pdf = fname:gsub('%.md$', '.pdf')
    table.insert(fname_pdfs, fname_pdf)
  end

  close_handler(_G.handler_viewer)
  _G.handler_viewer = vim.loop.spawn(opts.viewer,
  { args = fname_pdfs },
    vim.schedule_wrap(function(code_viewer, _)
      close_handler(_G.handler_viewer)
      if code_viewer ~= 0 then
        vim.notify(string.format('viewer %s failed with code %d',
          opts.viewer, code_viewer), vim.log.levels.ERROR)
      end
    end))
end

local function spawn_pandoc(args, opts)
  close_handler(_G.handler_md2pdf)
  _G.handler_md2pdf = vim.loop.spawn('md2pdf', {
    args = { '--' .. opts['pdf-engine'], unpack(args) },
  }, vim.schedule_wrap(function(code_md2pdf, _)
    close_handler(_G.handler_md2pdf)
    if code_md2pdf ~= 0 then
      vim.notify(string.format('md2pdf failed with code %d',
        code_md2pdf), vim.log.levels.ERROR)
    elseif opts.viewer then
      spawn_viewer(args, opts)
    end
  end))
end

local function md_to_pdf(tbl)
  local args, opts = parse_args(tbl.fargs)
  args = vim.tbl_deep_extend('force', { vim.fn.expand('%') }, args)
  opts = vim.tbl_deep_extend('force', { ['pdf-engine'] = 'pdflatex' }, opts)
  vim.cmd('silent! wall')
  spawn_pandoc(args, opts)
end

vim.api.nvim_buf_create_user_command(0, 'MarkdownToPDF', md_to_pdf, {
  nargs = '*',
  complete = complete_md_to_pdf,
  desc = 'Convert markdown to pdf'
})
