# neojj.nvim

A Neovim plugin for [jj (Jujutsu)](https://github.com/martinvonz/jj) version control.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'edmundmiller/neojj.nvim',
  dependencies = { 'NeogitOrg/neogit' },
  config = function()
    require('neojj').setup()
  end
}
```

## Usage

- `:NeoJJ` - Open the main neojj interface

## Configuration

```lua
require('neojj').setup({
  -- Configuration options will be added here
})
```

## Notes

- This plugin depends on Neogit and treats it as the Git backend and primary view renderer.
- Mappings invoke `:Neogit` subcommands where available. Adjust as Neogit APIs evolve.

## Tests

We use [mini.test](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-test.md) from `mini.nvim`.

Run locally (requires Neovim and mini.nvim available on runtimepath):

```sh
nvim --headless -u tests/minirc.lua +"lua MiniTest.run()" +qa
```

In CI we vendor `mini.nvim` into `tests/vendor/mini.nvim` automatically.
