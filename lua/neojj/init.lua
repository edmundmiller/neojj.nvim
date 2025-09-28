local M = {}

local defaults = {
  neogit = {}, -- forwarded to require('neogit').open(opts)
  mappings = {
    -- High-level jjui-inspired actions (wire them up incrementally)
    { key = "C", desc = "Commit",        cmd = "Neogit commit" },
    { key = "A", desc = "Amend",         cmd = "Neogit commit --amend" },
    { key = "S", desc = "Stage (hunk)",  cmd = "Neogit stage" },
    { key = "U", desc = "Unstage",       cmd = "Neogit unstage" },
    { key = "L", desc = "Log",           cmd = "Neogit log" },
    { key = "B", desc = "Branches",      cmd = "Neogit branch" },
    { key = "P", desc = "Push",          cmd = "Neogit push" },
    { key = "p", desc = "Pull",          cmd = "Neogit pull" },
    { key = "f", desc = "Fetch",         cmd = "Neogit fetch" },
    { key = "D", desc = "Diff toggle",   cmd = "Neogit diff" },
    -- H toggles the inline hints overlay
    { key = "H", desc = "Toggle hints",  callback = function(buf)
      require("neojj.hints").toggle(buf)
    end },
    -- ? opens a help overlay (alias to H)
    { key = "?", desc = "Help",          callback = function(buf)
      require("neojj.hints").toggle(buf)
    end },
  },
  hints = {
    border = "rounded",
    max_width = 80,
    winblend = 0,
  }
}

local function apply_mappings(bufnr, mappings)
  local function map(key, rhs, desc)
    vim.keymap.set("n", key, rhs, { buffer = bufnr, nowait = true, silent = true, desc = desc })
  end

  for _, m in ipairs(mappings or {}) do
    if m.callback then
      map(m.key, function() m.callback(bufnr) end, m.desc)
    elseif m.cmd then
      map(m.key, function()
        -- Prefer user commands; Neogit exposes :Neogit and subcommands.
        vim.cmd(m.cmd)
      end, m.desc)
    end
  end
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", defaults, opts or {})
end

-- Open Neogit and then layer jjui-like UX on top
function M.open()
  local ok, neogit = pcall(require, "neogit")
  if not ok then
    vim.notify("neojj: neogit not found. Please install Neogit.", vim.log.levels.ERROR)
    return
  end

  neogit.open(M.opts.neogit or {})

  -- Defer to let Neogit render its buffer, then attach
  vim.schedule(function()
    local bufnr = vim.api.nvim_get_current_buf()
    -- Attach hints with the active mapping roster
    require("neojj.hints").attach(bufnr, M.opts.mappings, M.opts.hints)
    apply_mappings(bufnr, M.opts.mappings)
  end)
end

return M