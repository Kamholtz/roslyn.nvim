local M = {}

local joinpath_log = {}

-- function M.handle_first_path(path, num_paths)
-- 	local out = path
-- 	if num_paths > 1 then
-- 	end
-- end

function M.joinpath_workaround(...)
	local paths = { ... }
	local path_out = ""
	for i, path in pairs(paths) do
		path_out = M.join_2_paths(path_out, path)
	end
	return vim.fs.normalize(path_out)
end

function M.remove_trailing_slashes(path)
	local backslashes_removed = string.gsub(path, "\\*$", "")
	local forward_slashes_removed = string.gsub(backslashes_removed, "/*$", "")
	return forward_slashes_removed
end

function M.remove_leading_slashes(path)
	local backslashes_removed = string.gsub(path, "^\\*", "")
	local forward_slashes_removed = string.gsub(backslashes_removed, "^/*", "")
	return forward_slashes_removed
end

function M.join_2_paths(path1, path2)
	if path1 == "" then
		return path2
	end

	-- ensure only one slash separates the two paths
	return M.remove_trailing_slashes(path1) .. "/" .. M.remove_leading_slashes(path2)
end

local use_workaround_joinpath = true

function M.joinpath(...)
	local args = { ... }
	local output = ""
	if use_workaround_joinpath then
		output = M.joinpath_workaround(...)
	else
		output = vim.fs.joinpath(...)
	end

	table.insert(joinpath_log, { args = args, output = output })
	return output
end

vim.api.nvim_create_user_command("PrintRoslynPathLog", function()
	print("PrintRoslynPathLog: ")
	print(vim.inspect(joinpath_log))
end, { range = true, nargs = 0, desc = "Print Roslyn path log" })

return M
