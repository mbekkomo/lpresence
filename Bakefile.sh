#!/usr/bin/env bash

# shellcheck disable=SC2155

util.check_luarocks_package() {
  luarocks show "$1" > /dev/null 2>&1
}

# dev
task.dev() {
  mkdir .luals
  declare -A submods=(
    ['lua-cjson']=https://github.com/goldenstein64/lua-cjson-definitions
  )

  for k in "${!submods[@]}"; do
    v="${submods[$k]}"
    git clone "$v" ".luals/$k"
  done

  luarocks init
  luarocks install --deps-only ./lpresence-dev-1.rockspec
}

# genrelease <{'revision','patch','minor','major'}> [push-tags]
task.genrelease() {
  local tags="$(git tag --sort=version:refname)"
  local tag_latest="$(tail -n 1 <<< "$tags")"

  if [[ -z "$tag_latest" ]]; then
    tag_latest="v0.0.0-1"
  fi

  tag_latest="${tag_latest#v}"

  local type="${1-}" version_next

  case "$type" in
    revision) version_next="$(awk -F- '{$2++; print $1"-"$2}' <<< "$tag_latest")" ;;
    patch) version_next="$(awk -F. '{$NF++; print $1"."$2"."$NF"-1"}' <<< "$tag_latest")" ;;
    minor) version_next="$(awk -F. '{$2++; $3=0; print $1"."$2"."$3"-1"}' <<< "$tag_latest")" ;;
    major) version_next="$(awk -F. '{$1++; $2=0; $3=0; print $1"."$2"."$3"-1"}' <<< "$tag_latest")" ;;
    *) bake.die "expected 'revision', 'patch', 'minor', 'major'. got '$type'" ;;
  esac

  rockspec="$(< ./lpresence-dev-1.rockspec)"
  rockspec="${rockspec//local _version/local _version = \"$version_next\"}"
  echo "$rockspec" > "lpresence-$version_next.rockspec"

  ldoc_config="$(< ./config.ld)"
  ldoc_config="${ldoc_config//local version/local version = \"$version_next\"}"
  echo "$ldoc_config" > config.ld.latest

  git add .
  git commit -m "release: version v$version_next"
  git tag -a "v$version_next" -m "Release: v$version_next"

  [[ -n "$2" ]] && git push origin main --follow-tags
  return 0
}

task.genmodules() {
  for f in lpresence/*; do
    : "${f%.lua}"
    echo "['${_//\//.}'] = "'"'"$f"'",'
  done
}

# gendoc [preview-generated-doc]
#watch: -i lua_modules -e lua
task.gendoc() {
  util.check_luarocks_package ldoc || luarocks install ldoc
  util.check_luarocks_package lua-discount || luarocks install lua-discount

  local ldoc_config="config.ld.latest"
  if [[ ! -f "$ldoc_config" && -n "$1" ]]; then
    ldoc_config="config.ld"
  fi

  ldoc -c "$ldoc_config" .

  if [[ -n "$2" ]] && bake.assert_cmd python; then
    python -mhttp.server -d doc/
  fi
}

# format
task.format() {
  stylua . ./lpresence-dev-1.rockspec ./config.ld
  while read -r f; do
    shfmt -w "$f"
  done < <(find . -name '*.sh' -not -path 'lua_modules')
}
