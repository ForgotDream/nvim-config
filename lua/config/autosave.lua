local M = { enabled = true, delay = 1000 }
local pending = {}

local function save(buf)
  if not M.enabled or not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
    return
  end
  local opt = vim.bo[buf]
  if not opt.modified or not opt.modifiable or opt.readonly or opt.buftype ~= "" then
    return
  end
  if vim.api.nvim_buf_get_name(buf) == "" or opt.filetype == "gitcommit" or opt.filetype == "gitrebase" then
    return
  end
  local ok, err = pcall(vim.api.nvim_buf_call, buf, function()
    vim.cmd("silent update")
  end)
  if not ok then
    vim.notify("自动保存失败：" .. tostring(err), vim.log.levels.WARN)
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup("OIAutoSave", { clear = true })
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "TextChangedP" }, {
    group = group,
    callback = function(event)
      if not M.enabled then
        return
      end
      local token = {}
      pending[event.buf] = token
      vim.defer_fn(function()
        if pending[event.buf] == token then
          pending[event.buf] = nil
          save(event.buf)
        end
      end, M.delay)
    end,
  })
  vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave", "FocusLost" }, {
    group = group,
    callback = function(event)
      pending[event.buf] = nil
      save(event.buf)
    end,
  })
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(event)
      pending[event.buf] = nil
    end,
  })
  vim.api.nvim_create_user_command("AutoSaveToggle", function()
    M.enabled = not M.enabled
    pending = {}
    vim.notify("自动保存：" .. (M.enabled and "开启" or "关闭"))
  end, { desc = "开关自动保存" })
end

return M
