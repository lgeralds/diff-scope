# diff-scope

diff-scope diffs two directories.

## Installation

```lua
# However plugins work for the user...
{ 'lgeralds/diff-scope' }

...

# Activate the extension
require('telescope').load_extension('diff-scope')
```
## Dependency

[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

## Instruction

```bash
:Telescope diff-scope diff
```
This will start a diff session. The user will need to supply two
directory paths.

```bash
Left Path: /Users/path/to/the/files
```
then
```bash
Right Path: /Users/path/to/the/other/files
```
The picker displays matched files and directories and their status. Status is noted with symbols.

- '+' added lines
- '-' removed lines
- '~' changed lines

The selected files are displayed juxtaposed in a single tab. 

The Left Path files will be shown in the left panel and 
Right Path files in the right panel.

Neovim's diff commands are available. Remeber to save changes before closing or quitting. 

Recall,
```bash
:Telescope diff-scope diff
```
to pick again.

Close the current diff tab.
```bash
:Telescope diff-scope close
```
Both tab buffers are editable. Any changes have to be explicitly
saved by the user before closing the tab. The tab will close without
warning the user about unsaved content.

Close all the diff tabs.
```bash
:Telescope diff-scope close-all
```

Close all the tabs and quit NeoVim.
```bash
:Telescope diff-scope bail
```
[closes all tabs and then Neovim using :qall!]

Switch tabs as usual. Maybe using
```bash
tabn
```
and its sibling commands. [Telescope-tabs](https://github.com/LukasPietzschmann/telescope-tabs) 
are nice.

Use the diff-scope commands for closing the tabs.
Other methods might leave orphaned buffers.

Start a new diff session with new directories.
```bash
:Telescope diff-scope new
```

Also, note
```bash
:Telescope resume
```
relaunchs the previous Telescope session in the same state as exited.

## Configuration

```lua
require('telescope').setup {
  extensions['diff-dir'] = {
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
    -- Colors reference Neovim highlight names
    -- Use :Telescope highlights to access highlight names
    colors = {
      file = '@field',
      folder = '@comment',
      added = '@character',
      deleted = '@exception',
      changed = '@attribute',
    },
  }
}
```



diff-scope began as a fork of [dirdiff.nvim](https://github.com/cossonleo/dirdiff.nvim).
