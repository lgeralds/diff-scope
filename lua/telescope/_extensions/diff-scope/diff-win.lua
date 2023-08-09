local api = vim.api
local M = {
  tab_buf = {}
}

function M:close_cur_tab()
  local cur_tab = api.nvim_get_current_tabpage()
  local bufs = self.tab_buf[cur_tab] or {}
  self.tab_buf[cur_tab] = {}

  for _, buf in ipairs(bufs) do
    if api.nvim_buf_is_valid(buf) then
      api.nvim_buf_delete(buf, {})
    end
  end
  api.nvim_command('tabclose')
end

function M:close_all_tab()
  for i, bufs in pairs(self.tab_buf) do
    self.tab_buf[i] = {}
    for _, buf in ipairs(bufs) do
      if api.nvim_buf_is_valid(buf) then
        api.nvim_buf_delete(buf, {})
      end
    end
  end
  api.nvim_command('tabclose')
end

function M:bail()
  api.nvim_command("qall!")
end

function M:create_diff_view(mine, other)
  api.nvim_command("tabnew")
  api.nvim_command("vs")

  self.tab_buf[api.nvim_get_current_tabpage()] = {
    self:create_buf_view(other, 'h'),
    self:create_buf_view(mine, 'l')
  }

  vim.diagnostic.config({ virtual_text = false, virtual_lines = false })
end

function M:create_buf_view(content, placement)
  api.nvim_command('wincmd ' .. placement)
  api.nvim_command('edit ' .. content)
  api.nvim_command('diffthis')
  api.nvim_win_set_option(
    api.nvim_get_current_win(),
    'signcolumn',
    'no'
  )
  api.nvim_command('')

  return api.nvim_get_current_buf()
end

return M
