return {
	{ "p00f/clangd_extensions.nvim", ft = { "c", "cpp", "objc", "objcpp", "cuda" }, opts = {} },
	{
		"Civitasv/cmake-tools.nvim",
		ft = { "c", "cpp", "cmake" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			cmake_build_directory = "build",
			cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" },
		},
	},
}
