local error_kind = require("lpresence.error_kind")

local lfs = require("lfs")

local utils = {}

utils.on_windows = package.config:sub(1, 1) == "\\"

---@param module string
---@param msg string
---@return any
function utils.assert_require(module, msg)
    local _, m = xpcall(require, function()
        error(error_kind.module_not_found(module, msg))
    end, module)
    return m
end

---@param id integer
---@return string?
function utils.get_ipc_path(id)
    local dir
    if utils.on_windows then
        dir = [[\\?\pipe\]]
    else
        dir = (os.getenv("XDG_RUNTIME_DIR") or os.getenv("TMPDIR") or os.getenv("TMP") or os.getenv("TEMP") or "/tmp"):gsub(
            "/$",
            ""
        ) .. "/"
    end

    for f in lfs.dir(dir) do
        if f:match("^discord%-ipc%-" .. (id or "")) then return dir .. f end
    end
end

return utils
