# Neovim configuration

This is Dene's portable Neovim setup for Linux and Apple Silicon macOS. Lua
owns editor behavior. Nix supplies Neovim and fallback command-line tools;
project flakes and direnv stay in front of those fallbacks, so each repository
can still select the compiler, Python, language server, and formatter it needs.

## Modernization checklist

The order keeps the editor usable after every stage.

### 1. Stabilize and diagnose

- [x] Preserve the existing language configuration work.
- [x] Stop updating plugins during startup.
- [x] Add explicit plugin update, sync, reload, and health commands.
- [x] Verify a clean headless startup.
- [x] Authenticate Windsurf on this computer with `:Codeium Auth`.

### 2. Make the editor portable with Nix

- [x] Add a locked flake for `x86_64-linux` and `aarch64-darwin`.
- [x] Package the Lua configuration into an immutable Neovim wrapper.
- [x] Package shared language servers, formatters, debuggers, and search tools.
- [x] Put project-provided tools before the packaged fallbacks on `PATH`.
- [x] Export a package, app, formatter, checks, and development shell.
- [x] Package Lazy, every plugin, and Treesitter grammars for a network-free first launch.
- [ ] Add this flake as an input to the NixOS/Home Manager flake after this repo is committed and pushed.
- [ ] Validate `nix run` on the MacBook.

### 3. Reorganize and consolidate

- [x] Separate core options, keymaps, autocmds, commands, and health checks.
- [x] Group plugins by capability and language.
- [x] Remove automatic update behavior, dead variables, and duplicate commenting.
- [x] Use Snacks as the picker, explorer, dashboard, and terminal frontend.
- [x] Retire Alpha, Telescope workflows, and Comment.nvim.
- [x] Keep fzf-lua only as an implementation dependency of live-preview.
- [x] Give added keymaps descriptions for which-key.
- [ ] Move each language's native LSP settings next to its language plugins.
- [ ] Review Noice, Notify, and highlight-colors after using the new setup for a while.

### 4. Modern language tooling

- [x] Use Neovim 0.12's native `vim.lsp.config` and `vim.lsp.enable` APIs.
- [x] Remove lsp-zero and the Mason tool-installation stack.
- [x] Configure LuaLS with lazydev.
- [x] Configure Python with Ruff, ty, uv helpers, pytest, and debugpy.
- [x] Configure Rust with rustaceanvim, rust-analyzer, Clippy, and crates.nvim.
- [x] Configure C/C++ with clangd, clang-tidy, ClangFormat, CMake, CTest, and LLDB.
- [x] Detect a missing or stale C/C++ compilation database.
- [x] Add source/header switching and a persistent symbol outline.
- [ ] Regenerate Pawian's stale `compile_commands.json` inside its current Nix environment.

### 5. Editing, navigation, tests, debugging, and Git

- [x] Replace formatter.nvim with Conform and controlled LSP fallback.
- [x] Add format-on-save controls.
- [x] Move Treesitter to its current API and add structural textobjects/motions.
- [x] Add folds, surround operations, fast visible jumps, and an outline.
- [x] Add neotest actions for pytest and CTest/GoogleTest projects.
- [x] Use rustaceanvim's native Rust testables instead of a second Rust test adapter.
- [x] Add DAP for debugpy and LLDB, including `.vscode/launch.json` reuse.
- [x] Add Gitsigns hunk operations and Diffview history/reviews.
- [x] Add project and recent-file navigation.
- [ ] Validate navigation, formatting, tests, and debugging in a Rust project.
- [ ] Validate the same workflow in uv Python and mixed Rust/Python projects.
- [ ] Validate ROOT, Boost, GSL, tests, and debugging in Pawian.

## Install and run

From this checkout:

```bash
nix run .
```

Build and validate it without launching the editor:

```bash
nix flake check
nix build
```

Enter a shell containing the configuration formatters:

```bash
nix develop
```

The wrapper contains fallback tools including clangd, LLDB, LuaLS, nixd,
rust-analyzer, Ruff, ty, uv, debugpy, CMake, fd, fzf, and ripgrep. Because the
wrapper appends these to `PATH`, a project's `nix develop` or direnv environment
wins. Open Neovim after `direnv allow`, or from inside `nix develop`, when a
project pins a special toolchain.

The packaged copy is immutable. For rapid config work, use your ordinary
`nvim` command, edit this checkout, and restart Neovim. Use `nix run .` to test
the version that another computer will receive.

The packaged editor gets Lazy, every plugin, and all Treesitter grammars from
the pinned Nixpkgs input and starts in a clean home without downloading files.
The normal development launch still uses `lazy-lock.json`, which makes rapid Lua
and plugin work convenient while keeping those plugin revisions reviewable.

## Finding commands without memorizing them

The leader key is `;`. Press `;`, pause, and use which-key's menu. The groups
are organized by job: `;f` files, `;l` language tools, `;t` tests, `;d`
debugging, `;g` Git, `;a` AI, `;u` UI toggles, and `;p` plugins.

Useful starting points:

| Keys | Action |
| --- | --- |
| `;;` | Search text throughout the project |
| `;ff` | Find a file |
| `;fb` | Switch buffers |
| `;fp` | Open a project |
| `;fo` | Open a recent file |
| `;fr` | Search and replace across files with grug-far |
| `;e` | Toggle the Snacks file explorer |
| `;<Space>` | Return to the dashboard |
| `;tt` | Toggle a terminal with the current project environment |
| `H` / `L` | Previous / next visible buffer |
| `;x` / `;X` | Close / restore a buffer |

Snacks project history is learned from files and projects you open. It is a
quick way to move among existing repositories without navigating directories.

## Navigation and structural editing

The normal LSP motions are `gd` definition, `gD` declaration, `gi`
implementation, `go` type definition, `gr` references, and `gs` signature
help. `;la` opens code actions and `;lr` renames a symbol.

Trouble gives stable, navigable lists: `;ld` for workspace diagnostics, `;lw`
for the current buffer, `;lR` for references, and `;ls` for symbols. `;lo`
opens Aerial's persistent outline. `;lh` toggles full diagnostic text beneath
the current line.

Flash replaces slow repeated searches through visible text. Press `s`, type a
few target characters, then type the label shown at the destination. `S` uses
the syntax tree to select or jump across code structures.

Treesitter adds language-aware objects. In visual or operator-pending mode,
`af`/`if` select around/inside a function and `ac`/`ic` do the same for a
class. `]f` and `[f` jump between functions; `]c` and `[c` jump between
classes. These compose with Vim operators, such as `daf` to delete a function.

mini.surround uses `sa` to add surrounding characters, `sd` to delete them,
and `sr` to replace them. For example, select text and type `sa"` to quote it,
or type `sr)'` to replace parentheses with single quotes. Native Neovim
commenting uses `gc` with a motion and `gcc` for the current line.

Folds are syntax aware, but files always open fully unfolded. Use ordinary Vim
commands such as `za` to toggle the fold under the cursor, `zR` to open all
folds, and `zM` to close all folds.

## Completion and Windsurf

nvim-cmp combines LSP results, snippets, paths, buffer words, and Windsurf.
Use `Ctrl-n`/`Ctrl-p` or `Tab`/`Shift-Tab` to move through completion items,
`Enter` to accept the selected item, and `Ctrl-e` to dismiss the menu.

Windsurf's current plugin and commands still use the old Codeium name. On each
computer, run:

```vim
:Codeium Auth
```

Finish the browser login once, then use `;at` or `:Codeium Toggle` to enable
or disable AI completions. `:checkhealth codeium` diagnoses authentication and
language-server problems. Windsurf appears in the same cmp popup as LSP,
snippet, path, and buffer suggestions. Use `Tab`/`Shift-Tab` or
`Ctrl-n`/`Ctrl-p` to select an item and `Enter` to accept it. Inline ghost text
is disabled so it cannot compete with the completion menu for `Tab`.

## Formatting and diagnostics

Conform formats on save using the project-visible executable. `;lf` formats
immediately. `:FormatToggle` toggles automatic formatting globally for the
current Neovim session; `:FormatToggle!` affects only the current buffer.
`:ConformInfo` reports the selected formatter and executable.

Configured formatters include ClangFormat, Ruff, rustfmt, StyLua, nixfmt,
Prettier, Taplo, and bibtex-tidy where applicable. LSP formatting is only used
as a fallback, which avoids two tools rewriting the same buffer.

Diagnostics appear as signs and a virtual line for the current line. Use
`]d`/`[d` for normal Neovim diagnostic navigation, `;lw` for the current
buffer list, or `;ld` for the whole workspace.

## C and C++

clangd provides completion, cross-references, semantic diagnostics,
clang-tidy, and header insertion. `;lc` switches between a source and header.
CMake Tools understands CMake configure/build directories, but project `just`
commands remain available in `;tt` and are often the more reproducible entry
point.

clangd depends on the exact compiler flags used to build each file. Prefer a
`compile_commands.json` generated by CMake with
`-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`; `build/compile_commands.json` is also
recognized. `;lC` or `:CppHealth` locates it and detects build directories that
no longer exist. The check also runs when clangd attaches. If it reports a
stale path, regenerate the database from the active project flake rather than
editing paths by hand.

For a Nix C++ project, enter its directory normally and let direnv activate the
flake in the existing shell, then launch the usual `nvim`. There is no need to
enter an interactive `nix develop` shell. The clangd configuration permits only
compiler drivers under Nix store GCC/Clang wrapper paths, allowing clangd to
discover the standard library and the project environment's system headers.

For CTest, Catch2, doctest, and supported GoogleTest projects, use the common
neotest keys below. The build tree must already exist and include CTest's test
metadata. Pawian's current compilation database refers to its former checkout,
so that project still needs regeneration before clangd results can be trusted.

## Rust

rustaceanvim owns rust-analyzer so it does not compete with the general LSP
setup. It runs workspace-wide Clippy checks and enables useful inlay hints.
`:RustLsp testables` lists and runs tests discovered by rust-analyzer;
`:RustLsp debuggables` discovers debug targets. crates.nvim adds crate version
and feature help while editing `Cargo.toml`.

Use the project's flake/direnv toolchain when it pins Rust or native libraries.
The packaged rust-analyzer is a fallback for repositories without one.

## Python

Ruff handles linting, import organization, and formatting. ty supplies type
checking. uv.nvim adds commands and `;r` mappings for uv environments; press
`;r` and pause to see the available actions.

neotest-python runs pytest. nvim-dap-python uses `.venv/bin/python` when that
environment exists at the project root, then falls back to the first `python3`
on `PATH`. The Nix wrapper's fallback Python includes debugpy. Inside a project,
include debugpy in the project's development environment if its Python takes
precedence.

## Tests

| Keys | Action |
| --- | --- |
| `;tn` | Run the nearest test |
| `;tf` | Run every test in the current file |
| `;ts` | Toggle the test tree and results summary |
| `;to` | Open output for the selected test |
| `;td` | Debug the nearest supported test through DAP |
| `;tS` | Stop the current test run |

Python uses pytest. C and C++ use CTest, which also understands supported
GoogleTest, Catch2, and doctest tests. Rust uses rustaceanvim's
`:RustLsp testables` because rust-analyzer already has exact Cargo knowledge.

## Debugging

| Keys | Action |
| --- | --- |
| `;db` | Toggle a breakpoint |
| `;dB` | Add a conditional breakpoint |
| `;dc` | Launch or continue |
| `;di` / `;do` / `;dO` | Step into / over / out |
| `;dr` | Open the debugger REPL |
| `;du` | Toggle the debugger UI |

Python uses debugpy. C, C++, and Rust use `lldb-dap`, available in the Nix
wrapper on both Linux and macOS. `;dc` prompts for an executable when a project
does not define a launch target. If `.vscode/launch.json` exists, its LLDB
targets are loaded too. Build native executables with debug symbols before
launching them.

## Git

Gitsigns works on individual changed hunks: `]h`/`[h` move between hunks,
`;gp` previews one, `;gs` stages one, `;gr` resets one, and `;gb` toggles
current-line blame. In operator or visual mode, `ih` selects a hunk.

Use `:DiffviewOpen` for a multi-file review and `:DiffviewFileHistory` for
history. These are review tools; they do not commit or push changes.

## Configuration maintenance

- `:PluginsUpdate` deliberately fetches newer plugin revisions and updates
  `lazy-lock.json` in the normal development launch. Packaged plugins update with
  `nix flake update` and a rebuild.
- `:PluginsSync` installs and removes plugins to match the Lua specs.
- `:ConfigHealth` runs the core LSP, Treesitter, and Lazy health checks.
- `:ConfigReload` reloads core Lua modules; restart after changing plugin specs.
- `;pp` opens Lazy and `;pu` starts an explicit update.

Review `lazy-lock.json` beside any plugin changes. If an update regresses,
restore the lock file and run `:PluginsSync`. Neither startup nor the Nix build
updates it automatically.
