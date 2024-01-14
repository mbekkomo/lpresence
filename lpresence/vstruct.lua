---@diagnostic disable-next-line:unused-local
local vstruct_ok, vstruct = pcall(require, "vstruct")
if not (string.pack and string.unpack) and not vstruct_ok then
    error(
        "vstruct is required on Lua environment that doesn't support string.{,un}pack (i.e before Lua 5.3), see https://github.com/toxicfrog/vstruct/#31-installation"
    )
end

return vstruct_ok and vstruct
