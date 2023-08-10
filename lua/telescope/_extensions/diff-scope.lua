local ok, telescope = pcall(require, 'telescope')

if not ok then
  error 'Install nvim-telescope/telescope.nvim to use lgeralds/diff-scope.'
end

local DiffScope = require('telescope._extensions.diff-scope.diff-scope-picker')
local opts = {
  path_a = vim.fn.getcwd(),
  path_b = vim.fn.getcwd(),
  ignore = { '.DS_Store', '.git', 'log', 'tmp', 'node_modules', '.Trash' },
  icons = {
    file = '',
    folder = '',
    added = '',
    deleted = '',
    changed = 'ﰣ',
  },
  colors = {
    file = '@field',
    folder = '@comment',
    added = '@character',
    deleted = '@exception',
    changed = '@attribute',
  },
}

return telescope.register_extension {
  setup = function(diff_scope_opts, _)
    opts = vim.tbl_extend('force', opts, diff_scope_opts)
  end,
  exports = {
    diff = function()
      DiffScope.diff(opts)
    end,
    close = DiffScope.close,
    close_all = DiffScope.close_all,
    bail = DiffScope.bail,
    new = DiffScope.new,
  },
}
