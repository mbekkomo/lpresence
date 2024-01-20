---@diagnostic disable
local _version = ""
rockspec_format = "3.0"

package = "lpresence"
version = "dev-1"
source = {
    url = "git+https://github.com/komothecat/lpresence.git",
    branch = "main",
}
description = {
    homepage = "https://github.com/komothecat/lpresence",
    issues_url = "https://github.com/komothecat/lpresence/issues",
    license = "MIT",
    
    summary = "A Lua wrapper for Discord IPC and RPC. ",
    detailed = [[
A Lua wrapper for Discord IPC and RPC.

More information is on the GitHub page.
]]
}
dependencies = {
    "lua >= 5.1, < 5.5",
    "lua-cjson >= 2.1.0.10",
    "classy >= 0.4",
    "luafilesystem >= 1.8.0",
    "vstruct >= 2.1.1",
    platforms = {
        unix = {
            "cqueues >= 20200726",
        },
        windows = {
            "winapi >= 1.4.2",
        },
    }
}
build = {
    type = "builtin",
    modules = {},
}
