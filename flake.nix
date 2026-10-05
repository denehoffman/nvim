{
  description = "Dene's portable Neovim configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfreePredicate =
              package:
              builtins.elem (nixpkgs.lib.getName package) [
                "barbar.nvim"
                "codeium"
              ];
          };
          plugins = with pkgs.vimPlugins; [
            aerial-nvim
            barbar-nvim
            catppuccin-nvim
            clangd_extensions-nvim
            cmake-tools-nvim
            cmp-buffer
            cmp-nvim-lsp
            cmp-path
            cmp_luasnip
            conform-nvim
            crates-nvim
            diffview-nvim
            flash-nvim
            friendly-snippets
            fzf-lua
            gitsigns-nvim
            grug-far-nvim
            inc-rename-nvim
            lazydev-nvim
            live-preview-nvim
            lsp_lines-nvim
            lualine-nvim
            luasnip
            markview-nvim
            mini-ai
            mini-surround
            neotest
            neotest-ctest
            neotest-python
            noice-nvim
            nui-nvim
            nvim-autopairs
            nvim-cmp
            nvim-dap
            nvim-dap-python
            nvim-dap-ui
            nvim-highlight-colors
            nvim-lspconfig
            nvim-nio
            nvim-notify
            nvim-origami
            nvim-treesitter-textobjects
            nvim-web-devicons
            plenary-nvim
            remember-nvim
            rustaceanvim
            snacks-nvim
            todo-comments-nvim
            trouble-nvim
            typst-preview-nvim
            uv-nvim
            vim-sleuth
            vimtex
            which-key-nvim
            windsurf-nvim
            (nvim-treesitter.withAllGrammars)
          ];
          pluginLinks = pkgs.linkFarm "dene-neovim-plugins" (
            (map (plugin: {
              name = plugin.pname;
              path = plugin;
            }) plugins)
            ++ [
              {
                name = "catppuccin";
                path = pkgs.vimPlugins.catppuccin-nvim;
              }
              {
                name = "LuaSnip";
                path = pkgs.vimPlugins.luasnip;
              }
            ]
          );
          configRoot = builtins.path {
            path = ./.;
            name = "dene-neovim-config";
            filter =
              path: type:
              let
                name = baseNameOf path;
              in
              name != ".git" && name != "result" && name != ".direnv";
          };
          fallbackTools =
            with pkgs;
            [
              bash
              bibtex-tidy
              cargo
              clang-tools
              cmake
              fd
              fzf
              git
              lua-language-server
              llvmPackages.lldb
              ninja
              nixd
              nodejs
              (python3.withPackages (ps: [ ps.debugpy ]))
              pkg-config
              ripgrep
              ruff
              rust-analyzer
              rustc
              rustfmt
              stylua
              taplo
              tree-sitter
              ty
              uv
            ]
            ++ lib.optionals stdenv.hostPlatform.isLinux [ gdb ];
          generatedInit = pkgs.writeText "dene-neovim-init.lua" ''
            vim.opt.runtimepath:prepend(${builtins.toJSON configRoot})
            dofile(${builtins.toJSON "${configRoot}/init.lua"})
          '';
          neovim = pkgs.symlinkJoin {
            name = "dene-neovim";
            paths = [
              pkgs.neovim-unwrapped
              pluginLinks
            ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram "$out/bin/nvim" \
                --add-flags "-u ${generatedInit}" \
                --set DENE_NIX_LAZY_PATH ${pkgs.vimPlugins.lazy-nvim} \
                --set DENE_NIX_PLUGIN_ROOT ${pluginLinks} \
                --suffix PATH : ${pkgs.lib.makeBinPath fallbackTools}
            '';
            meta.mainProgram = "nvim";
          };
        in
        {
          default = neovim;
          inherit neovim;
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${nixpkgs.lib.getExe self.packages.${system}.default}";
        };
      });

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          packages = [
            nixpkgs.legacyPackages.${system}.nixfmt
            nixpkgs.legacyPackages.${system}.stylua
          ];
        };
      });

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          package = self.packages.${system}.default;
          formatting =
            pkgs.runCommand "neovim-config-formatting"
              {
                nativeBuildInputs = [
                  pkgs.nixfmt
                  pkgs.stylua
                ];
              }
              ''
                		      nixfmt --check ${./flake.nix}
                		      stylua --check ${./init.lua} ${./lua}
                		      touch $out
                		    '';
        }
      );
    };
}
