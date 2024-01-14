local utils = require("lpresence.utils")

---@diagnostic disable-next-line:unused-local
local winapi_ok, winapi = pcall(require, "winapi")
if utils.on_windows and not winapi_ok then
    error("winapi is required on Windows platform to run lpresence, see https://stevedonovan.github.io/winapi")
end

return winapi_ok and winapi
