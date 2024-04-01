local M = require("roslyn.path_workaround")
local mini_test = require("mini.test")
local T = mini_test.new_set()

local test_data = {
	{
		args = { "C:\\Users\\abc\\AppData\\Local\\nvim-data", "roslyn" },
		output = "C:\\Users\\abc\\AppData\\Local\\nvim-data/roslyn",
	},
	{
		args = { "C:\\Users\\carlk\\AppData\\Local\\nvim-data", "roslyn", "Microsoft.CodeAnalysis.LanguageServer.dll" },
		output = "C:\\Users\\carlk\\AppData\\Local\\nvim-data/roslyn/Microsoft.CodeAnalysis.LanguageServer.dll",
	},
}

-- local M = {}
T.path_workaround = mini_test.new_set()

-- function T.path_workaround.test_1()
-- 	mini_test.expect.equality(path_workaround.joinpath("a", "b"), "c")
-- end

function M.remove_leading_slashes(path)
	local backslashes_removed = string.gsub(path, "^\\*", "")
	local forward_slashes_removed = string.gsub(backslashes_removed, "^/*", "")
	return forward_slashes_removed
end

function T.path_workaround.remove_leading_slash_forward()
	mini_test.expect.equality(M.remove_leading_slashes("/a"), "a")
end

function T.path_workaround.remove_leading_slash_2_forward()
	mini_test.expect.equality(M.remove_leading_slashes("//a"), "a")
end

function T.path_workaround.remove_leading_slash_back()
	mini_test.expect.equality(M.remove_leading_slashes("\\a"), "a")
end

function T.path_workaround.remove_leading_slash_2_back()
	mini_test.expect.equality(M.remove_leading_slashes("\\\\a"), "a")
end

function T.path_workaround.join_2_paths_empty_path1()
	mini_test.expect.equality(M.join_2_paths("", "a"), "a")
end

function T.path_workaround.join_2_paths_empty_path1_path2_has_leading_slash()
	mini_test.expect.equality(M.join_2_paths("", "/a"), "/a")
end

function T.path_workaround.join_2_paths_path1_has_trailing_slash()
	mini_test.expect.equality(M.join_2_paths("a/", "b"), "a/b")
end

function T.path_workaround.join_2_paths_path1_has_trailing_slash_path2_has_leading_slash()
	mini_test.expect.equality(M.join_2_paths("a/", "/b"), "a/b")
end

function T.path_workaround.join_2_paths_no_slashes()
	mini_test.expect.equality(M.join_2_paths("a", "b"), "a/b")
end

function M.joinpath_workaround(...)
	local paths = { ... }
	local path_out = ""
	for i, path in pairs(paths) do
		path_out = M.join_2_paths(path_out, path)
	end
	return vim.fs.normalize(path_out)
end

function T.path_workaround.joinpath_workaround()
	mini_test.expect.equality(M.joinpath_workaround("a", "b", "/c.fnl"), "a/b/c.fnl")
end

function T.path_workaround.joinpath_workaround_2()
	mini_test.expect.equality(M.joinpath_workaround("a/", "/b/", "/c.fnl"), "a/b/c.fnl")
end

function T.path_workaround.joinpath_workaround_3()
	mini_test.expect.equality(M.joinpath_workaround("", "/a/", "/b/", "/c.fnl"), "/a/b/c.fnl")
end

return T
