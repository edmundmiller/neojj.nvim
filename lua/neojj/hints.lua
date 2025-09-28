-- Hints overlay functionality for neojj.nvim
local M = {}

-- Storage for attached hint overlays
local attached_hints = {}

-- Create and show hints overlay for a buffer
function M.attach(bufnr, hints, opts)
  opts = opts or {}
  
  -- Store the hints configuration for this buffer
  attached_hints[bufnr] = {
    hints = hints,
    opts = opts,
    win_id = nil
  }
end

-- Toggle hints overlay visibility for a buffer
function M.toggle(bufnr)
  local hint_data = attached_hints[bufnr]
  if not hint_data then
    return
  end
  
  -- Check if window is currently open
  if hint_data.win_id and vim.api.nvim_win_is_valid(hint_data.win_id) then
    -- Close the window
    vim.api.nvim_win_close(hint_data.win_id, true)
    hint_data.win_id = nil
  else
    -- Create and show the hints window
    local hint_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[hint_buf].filetype = 'neojj-hints'
    
    -- Create content from hints
    local lines = {}
    for _, hint in ipairs(hint_data.hints) do
      table.insert(lines, hint.key .. ': ' .. hint.desc)
    end
    vim.api.nvim_buf_set_lines(hint_buf, 0, -1, false, lines)
    
    -- Create floating window
    local win_opts = {
      relative = 'win',
      width = 30,
      height = #lines,
      row = 1,
      col = 1,
      style = 'minimal',
      border = hint_data.opts.border or 'none'
    }
    
    hint_data.win_id = vim.api.nvim_open_win(hint_buf, false, win_opts)
  end
end

return M