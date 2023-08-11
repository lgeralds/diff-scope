local api = vim.api
local M = {
  tab_buf = {}
}

function M:close_cur_tab()
  -- ts = api.nvim_tabpage_get_number(api.nvim_get_current_tabpage())
  -- print('TS: ', vim.inspect(ts))

  local cur_tab = api.nvim_get_current_tabpage()
  -- if api.nvim_tabpage_get_number(cur_tab) < 2 then
  --   return
  -- end
  local bufs = self.tab_buf[cur_tab] or {}
  self.tab_buf[cur_tab] = {}

  for _, buf in ipairs(bufs) do
    if api.nvim_buf_is_valid(buf) then
      api.nvim_buf_delete(buf, { force = true })
    end
  end

  if api.nvim_tabpage_is_valid(cur_tab) and api.nvim_tabpage_get_number(cur_tab) > 1 then
    api.nvim_command('tabclose')
  end
end

function M:close_all_tab()
  -- ts = api.nvim_tabpage_get_number(api.nvim_get_current_tabpage())
  -- print('TS: ', vim.inspect(ts))
  -- local cur_tab = api.nvim_get_current_tabpage()
  -- if api.nvim_tabpage_get_number(cur_tab) < 2 then
  --   return
  -- end

  for i, bufs in pairs(self.tab_buf) do
    self.tab_buf[i] = {}
    for _, buf in ipairs(bufs) do
      if api.nvim_buf_is_valid(buf) then
        api.nvim_buf_delete(buf, { force = true })
      end
    end
    if api.nvim_tabpage_is_valid(i) and api.nvim_tabpage_get_number(i) > 1 then
      api.nvim_command('tabclose ')
    end
  end

  -- api.nvim_command('tabclose')
end

function M:bail()
  api.nvim_command("qall!")
end

function M:create_diff_view(mine, other)
  api.nvim_command('tabnew')
  api.nvim_command('vsplit')

  self.tab_buf[api.nvim_get_current_tabpage()] = {
    self:create_buf_view(other, 'l'),
    self:create_buf_view(mine, 'h')
  }

  vim.diagnostic.config({ virtual_text = false, virtual_lines = false })
end

function M:create_buf_view(content, placement)
  api.nvim_command('wincmd ' .. placement)
  api.nvim_command('visual ' .. content) -- editable
  -- api.nvim_command('view ' .. content) -- read only
  api.nvim_command('diffthis')
  api.nvim_win_set_option(
    api.nvim_get_current_win(),
    'signcolumn',
    'no'
  )

  return api.nvim_get_current_buf()
end

return M
