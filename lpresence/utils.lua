local lfs = require("lfs")

local utils = {}

utils.on_windows = package.config:sub(1, 1) == "\\"

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
