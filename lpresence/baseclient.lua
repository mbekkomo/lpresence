-- Enable compatibilty for Pluto 0.9.0+
-- @pluto_use class = false

local class = require("classy")
local json = require("cjson")
local copas = require("copas")
local socket = require("socket")
local utils = require("lpresence.utils")

---@diagnostic disable-next-line:unused-local
local vstruct_ok, vstruct = pcall(require, "vstruct")
if not (string.pack and string.unpack) and not vstruct_ok then
    error("vstruct is required on Lua environment that doesn't support string.{,un}pack (i.e before Lua 5.3), see https://github.com/toxicfrog/vstruct/#31-installation")
end

---@diagnostic disable-next-line:unused-local
local winapi_ok, winapi = pcall(require, "winapi")
if utils.on_windows and not winapi_ok then
    error("winapi is required on Windows platform to run lpresence, see https://stevedonovan.github.io/winapi")
end
