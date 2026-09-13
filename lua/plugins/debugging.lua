return {
	{
		"mfussenegger/nvim-dap",
		dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio", "mfussenegger/nvim-dap-python" },
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()
			local project_python = vim.fn.getcwd() .. "/.venv/bin/python"
			local python = vim.uv.fs_stat(project_python) and project_python or vim.fn.exepath("python3")
			require("dap-python").setup(python)

			local lldb_dap = vim.fn.exepath("lldb-dap")
			if lldb_dap ~= "" then
				dap.adapters.lldb = { type = "executable", command = lldb_dap, name = "lldb" }
				local native = {
					name = "Launch executable",
					type = "lldb",
					request = "launch",
					program = function()
						return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				}
				dap.configurations.cpp = { native }
				dap.configurations.c = dap.configurations.cpp
				dap.configurations.rust = dap.configurations.cpp
			end

			local launch_json = vim.fs.find(".vscode/launch.json", { path = vim.fn.getcwd(), upward = true })[1]
			if launch_json then
				require("dap.ext.vscode").load_launchjs(launch_json, { lldb = { "c", "cpp", "rust" } })
			end
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "toggle breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "conditional breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "continue / launch",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "step into",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "step over",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "step out",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.open()
				end,
				desc = "debug REPL",
			},
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "debug UI",
			},
		},
	},
}
