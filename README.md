# NeoJJ — jjui-style UX on top of Neogit

NeoJJ is a thin Neovim plugin that layers [jjui](https://github.com/idursun/jjui)-inspired interaction patterns over [Neogit](https://github.com/NeogitOrg/neogit). It keeps Neogit's powerful Git backend while making common actions more discoverable and faster to execute via single-key, context-aware mappings and an inline hints overlay.

Status: prototype scaffold. Safe to install; adds a `:NeoJJ` command that opens Neogit and shows jjui-style help.

## Install

Using lazy.nvim:

```lua
{
  "edmundmiller/neojj.nvim",
  dependencies = { "NeogitOrg/neogit" },
  config = function()
    require("neojj").setup({
      -- Customize key actions or hints styling
      -- mappings = { ... },
      -- hints = { border = "rounded", winblend = 0, max_width = 80 },
    })
  end,
}
```

## Usage

- `:NeoJJ` — opens Neogit and attaches jjui-style UX.
- Press `H` or `?` in the Neogit buffer to toggle the inline, discoverable hints.
- Default single-key actions include `C` (Commit), `A` (Amend), `S` (Stage), `U` (Unstage), `L` (Log), `B` (Branches), `P` (Push), `p` (Pull), `f` (Fetch), `D` (Diff).

You can override or extend mappings in `require("neojj").setup({ mappings = { ... } })`.

## Design principles (inspired by jjui)
- Discoverable: on-demand inline hints for the current context.
- Minimal friction: consistent, single-keystroke actions for common operations.
- Context first: act where you are (status, diff, log) without global modes.
- Non-blocking feedback: async ops with subtle, useful feedback.

## Roadmap

1. Solidify extension points:
   - Section-aware hint sets (Status vs Log vs Commit buffers).
   - Smarter detection/attachment to Neogit buffers.
2. Patch-centric workflows:
   - Hunk/line staging with previews and textual patch building.
3. Command palette:
   - Telescope picker for Neogit actions with fuzzy search and live descriptions.
4. Panels and layout:
   - Optional left "changes" panel + right diff panel orchestration.
5. Contextual operations:
   - Rebase flows (pick/reword/fixup), stash apply/pop, cherry-pick, bisect helpers.
6. Visual cues:
   - Inline statusline with branch/ahead-behind, WIP, dirty indicators.

## Notes

- This plugin depends on Neogit and treats it as the Git backend and primary view renderer.
- Mappings invoke `:Neogit` subcommands where available. Adjust as Neogit APIs evolve.
