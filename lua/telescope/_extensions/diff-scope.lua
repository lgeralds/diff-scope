local ok, telescope = pcall(require, 'telescope')

if not ok then
  error 'Install nvim-telescope/telescope.nvim to use lgeralds/diff-scope.'
end
print('tscope init')

local DiffScope = require('telescope._extensions.diff-scope.diff-scope-picker')
local opts = {
  path_a =
  [[/Users/lgeralds/Projects/t/ruby 3.2/r02/code 2/rails7/depot_a]],
  path_b =
  [[/Users/lgeralds/Projects/t/ruby 3.2/r02/code 2/rails7/depot_f]],
  ignore = { '.DS_Store' }
}

return telescope.register_extension {
  setup = function(diff_scope_opts, _)
    opts = vim.tbl_extend('force', opts, diff_scope_opts)
    -- print('REGISTERING', vim.inspect(opts))
  end,
  exports = {
    diff = function()
      DiffScope.diff(opts)
    end,
    close = DiffScope.close,
    close_all = DiffScope.close_all,
  },
}
