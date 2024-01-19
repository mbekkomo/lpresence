#!/usr/bin/env bash

task.dev() {
  mkdir .luals
  declare -A submods=(
    ['luasocket']=https://github.com/LuaCATS/luasocket
    ['lua-cjson']=https://github.com/goldenstein64/lua-cjson-definitions
  )

  for k in "${!submods[@]}"; do
    v="${submods[$k]}"
    git clone "$v" ".luals/$k"
  done

  luarocks init
  luarocks install --deps-only ./lpresence-dev-1.rockspec
}
