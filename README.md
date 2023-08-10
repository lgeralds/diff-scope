# diff-scope

diff-scope diffs two directories.

### Installation
```lua
{ 'lgeralds/diff-scope' }
```

```vim
:Telescope diff-scope diff
```
This will start a diff session. The user will need to supply two
directory paths.

```text
Left Path: /Users/path/to/the/files
```
then
```text
Right Path: /Users/path/to/the/other/files
```
The picker displays matched files and directories and their status. Status is noted with symbols.

- '+' added lines
- '-' removed lines
- '~' changed lines

The selected files are displayed juxtaposed in a single tab. 

The Left Path files will be shown in the left panel and 
Right Path files in the right panel.

Recall,
```vim
:Telescope diff-scope diff
```
to pick again.

Close the current tab.
```vim
:Telescope diff-scope close
```

Close all the tabs.
```vim
:Telescope diff-scope close-all
```

Close all the tabs and quit NeoVim.
```vim
:Telescope diff-scope bail
```
[closes all tabs and then Neovim using :qall!]

Switch tabs as usual. Maybe using,
```vim
tabn
```
and its sibling commands.

Use the diff-scope commands for closing the tabs.
Other methods might leave orphaned buffers.

Start a new diff session with new directories.
```vim
:Telescope diff-scope new
```

Also, note,
```vim
:Telescope resume
```
relaunchs the previous Telescope session is the same state as exited.

diff-scope began as a fork of [cossonleo/dirdiff](https://github.com/cossonleo/dirdiff.nvim).
