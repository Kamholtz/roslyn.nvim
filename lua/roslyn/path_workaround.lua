local M = {}

local joinpath_log = {}

function M.joinpath(...)
	local args = { ... }
	local output = vim.fs.joinpath(...)
	table.insert(joinpath_log, { args = args, output = output })
	return output
end

-- function M.handle_first_path(path, num_paths)
-- 	local out = path
-- 	if num_paths > 1 then
-- 	end
-- end

vim.api.nvim_create_user_command("PrintRoslynPathLog", function()
	print("PrintRoslynPathLog: ")
	print(vim.inspect(joinpath_log))
end, { range = true, nargs = 0, desc = "Print Roslyn path log" })

return M
