package = "lpresence"
version = "dev-1"
source = {
    url = "git+https://github.com/komothecat/lpresence.git",
}
description = {
    homepage = "https://github.com/komothecat/lpresence",
    license = "MIT",
}
dependencies = {
    "lua >= 5.1, < 5.5",
    "copas >= 4.7.0, < 4.8.0",
    "lua-cjson >= 2.1.0.10, < 2.2.0",
    "classy >= 0.4, < 0.5",
    "luafilesystem >= 1.8.0, < 1.9.0",
}
build = {
    type = "builtin",
    modules = {},
}
