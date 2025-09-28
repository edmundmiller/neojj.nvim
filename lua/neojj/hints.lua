local H = {}

local state_by_buf = {}

local function make_lines(mappings)
  local out = { "jjui-style actions (buffer-local):" }
  local line = {}
  local function flush()
    if #line > 0 then
      table.insert(out, table.concat(line, "    "))
      line = {}
    end
  end
  for _, m in ipairs(mappings or {}) do
    local label = string.format("%-2s %s", "[" .. m.key .. "]", m.desc or "")
    table.insert(line, label)
    if #line >= 2 then flush() end
  end
  flush()
  table.insert(out, "")
  table.insert(out, "Toggle with [H] or [?]")
  return out
end

local function create_float(bufnr, mappings, opts)
  opts = opts or {}
  local lines = make_lines(mappings)
  local width = 0
  for _, l in ipairs(lines) do width = math.max(width, #l) end
  width = math.min(width + 2, opts.max_width or 80)

  local height = #lines + 2
  local ui = vim.api.nvim_list_uis()[1]
  local win_w = ui and ui.width or vim.o.columns
  local win_h = ui and ui.height or vim.o.lines

  local row = math.floor(win_h * 0.8 - height)
  local col = math.floor((win_w - width) / 2)

  local floatbuf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(floatbuf, 0, -1, false, lines)
  vim.bo[floatbuf].modifiable = false
  vim.bo[floatbuf].bufhidden = "wipe"
  vim.bo[floatbuf].filetype = "neojj-hints"

  local win = vim.api.nvim_open_win(floatbuf, false, {
    relative = "editor",
    style = "minimal",
    border = opts.border or "rounded",
    row = row,
    col = col,
    width = width,
    height = height,
    noautocmd = true,
  })
  vim.wo[win].winblend = opts.winblend or 0
  vim.wo[win].wrap = false

  state_by_buf[bufnr] = { win = win, buf = floatbuf }
end

function H.attach(bufnr, mappings, opts)
  -- Create hidden state; no-op until toggled
  state_by_buf[bufnr] = state_by_buf[bufnr] or { win = nil, buf = nil, mappings = mappings, opts = opts }
end

function H.toggle(bufnr)
  local st = state_by_buf[bufnr]
  if not st then return end
  if st.win and vim.api.nvim_win_is_valid(st.win) then
    if vim.api.nvim_win_is_valid(st.win) then
      pcall(vim.api.nvim_win_close, st.win, true)
    end
    st.win = nil
    if st.buf and vim.api.nvim_buf_is_valid(st.buf) then
      pcall(vim.api.nvim_buf_delete, st.buf, { force = true })
    end
    st.buf = nil
  else
    create_float(bufnr, st.mappings or {}, st.opts or {})
  end
end

return H