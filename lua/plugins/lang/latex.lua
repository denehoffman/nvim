local function open_compile_output()
	local state = vim.b.vimtex
	local output = state and state.compiler and state.compiler.output
	if not output or vim.fn.filereadable(output) == 0 then
		vim.notify("No LaTeX compiler output yet", vim.log.levels.INFO)
		return
	end

	local source = vim.api.nvim_get_current_buf()
	vim.cmd("hide edit " .. vim.fn.fnameescape(output))
	vim.bo.bufhidden = "wipe"
	vim.bo.buflisted = false
	vim.bo.modifiable = false
	vim.bo.readonly = true
	vim.bo.autoread = true
	vim.cmd.normal({ "Gzb", bang = true })
	vim.keymap.set("n", "q", function()
		vim.cmd.buffer(source)
	end, { buffer = true, desc = "return to LaTeX source" })
end

return {
	{
		"lervag/vimtex",
		lazy = false,
		init = function()
			vim.g.vimtex_quickfix_mode = 0
			if vim.fn.executable("latexmk") == 0 and vim.fn.executable("tectonic") == 1 then
				vim.g.vimtex_compiler_method = "tectonic"
			else
				vim.g.vimtex_compiler_method = "latexmk"
			end

			if vim.fn.has("mac") == 1 then
				vim.g.vimtex_view_method = "skim"
			else
				vim.g.vimtex_view_method = "zathura_simple"
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("dene_latex", { clear = true }),
				pattern = "tex",
				callback = function(args)
					vim.keymap.set("n", "<localleader>lo", open_compile_output, {
						buffer = args.buf,
						desc = "show compiler output in this window",
					})
					vim.keymap.set("n", "<localleader>lf", function()
						Snacks.picker("vimtex_toc")
					end, { buffer = args.buf, desc = "find LaTeX section, label, or frame" })
					vim.keymap.set("n", "<localleader>lp", function()
						if not Snacks.image.supports_terminal() then
							vim.notify("LaTeX hover preview needs a Kitty graphics terminal", vim.log.levels.WARN)
							return
						end
						local ok, parser = pcall(vim.treesitter.get_parser, args.buf, "latex")
						if not ok or not parser then
							vim.notify("LaTeX hover preview needs the latex Treesitter parser", vim.log.levels.WARN)
							return
						end
						Snacks.image.hover()
					end, { buffer = args.buf, desc = "preview equation or graphic" })
				end,
			})
		end,
	},
	{
		"folke/snacks.nvim",
		opts = function()
			-- Supplying image opts to setup would also enable automatic image rendering.
			require("snacks").config.image.resolve = function(file, src)
				local bufnr = vim.fn.bufnr(file)
				local state = bufnr >= 0 and vim.b[bufnr].vimtex
				if state and state.root and not vim.startswith(src, "/") and not src:find("://", 1, true) then
					local path = vim.fs.joinpath(state.root, src)
					if vim.fn.filereadable(path) == 1 then
						return path
					end
				end
			end
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		config = function()
			local ls = require("luasnip")
			local parse = ls.parser.parse_snippet

			local function in_math()
				return vim.fn["vimtex#syntax#in_mathzone"]() == 1 and vim.fn["vimtex#syntax#in_comment"]() == 0
			end

			local function math(trig, name, body)
				return parse({ trig = trig, name = name, condition = in_math, show_condition = in_math }, body)
			end

			ls.add_snippets("tex", {
				math("mfrac", "fraction", [[\frac{${1:numerator}}{${2:denominator}}]]),
				math("mpart", "partial derivative", [[\frac{\partial ${1:f}}{\partial ${2:x}}]]),
				math(
					"mmat",
					"2-by-2 matrix (amsmath)",
					[[
\begin{pmatrix}
	${1:a} & ${2:b} \\\\
	${3:c} & ${4:d}
\end{pmatrix}]]
				),
				parse({ trig = "lqty", name = "quantity (siunitx v3)" }, [[\qty{${1:1.0}}{${2:\giga\electronvolt}}]]),
				parse(
					{ trig = "lalign", name = "aligned equations (amsmath)" },
					[[
\begin{align}
	${1:f(x)} &= ${2:expression}
	\label{eq:${3:key}}
\end{align}]]
				),
				parse(
					{ trig = "lfig", name = "figure (graphicx)" },
					[[
\begin{figure}[tbp]
	\centering
	\includegraphics[width=${1:0.8}\linewidth]{${2:figures/plot.pdf}}
	\caption{${3:Caption}}
	\label{fig:${4:key}}
\end{figure}]]
				),
				parse(
					{ trig = "lplot", name = "plot from a CSV file (pgfplots)" },
					[[
\begin{tikzpicture}
	\begin{axis}[xlabel={${1:x}}, ylabel={${2:y}}]
		\addplot table[col sep=comma, x=${3:x}, y=${4:y}] {${5:data.csv}};
	\end{axis}
\end{tikzpicture}]]
				),
				parse(
					{ trig = "lframe", name = "Beamer frame" },
					[[
\begin{frame}{${1:Title}}
	${2:Content}
\end{frame}]]
				),
				parse(
					{ trig = "lcols", name = "Beamer columns" },
					[[
\begin{columns}[T,onlytextwidth]
	\begin{column}{0.48\textwidth}
		${1:Left}
	\end{column}
	\begin{column}{0.48\textwidth}
		${2:Right}
	\end{column}
\end{columns}]]
				),
			}, { key = "dene_latex" })
		end,
	},
}
