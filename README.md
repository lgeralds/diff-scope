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
The Left Path files will be shown in the left panel and 
Right Path files in the right panel.

```vim
:Telescope diff-scope close
```

```vim
:Telescope diff-scope close-all
```

```vim
:Telescope diff-scope bail
```
closes all tabs and then Neovim using :qall!.

Also, note,
```vim
:Telescope resume
```
relaunchs the previous Telescope session is the same state as exited.

diff-scope began as a fork of [cossonleo/dirdiff](https://github.com/cossonleo/dirdiff.nvim).
