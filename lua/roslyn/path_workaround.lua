local M = {}

local joinpath_log = {}

function M.joinpath(...)
	local args = { ... }
	local output = vim.fs.joinpath(...)
	joinpath_log:insert({ args = args, output = output })
	return output
end

vim.api.nvim_create_user_command("PrintRoslynPathLog", function()
	print("PrintRoslynPathLog: ")
	print(vim.inspect(joinpath_log))
end, { range = true, nargs = 0, desc = "Print Roslyn path log" })

return M
