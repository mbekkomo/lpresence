#!/usr/bin/env bash

# shellcheck disable=SC2155

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

task.genrelease() {
  local tags="$(git tag --sort=version:refname)"
  local tag_latest="$(tail -n 1 <<< "$tags")"
 
  if [[ -z "$tag_latest" ]]; then
    tag_latest="v0.1.0-1"
  fi
 
  tag_latest="${tag_latest#v}"

  local type="${1-}" version_next

  case "$type" in
    revision) version_next="$(awk -F- '{$2++; print $1"-"$2}')";;
    patch) version_next="$(awk -F. '{$NF++; print $1"."$2"."$NF}' <<< "$tag_latest")";;
    minor) version_next="$(awk -F. '{$2++; $3=0; print $1"."$2"."$3}' <<< "$tag_latest")";;
    major) version_next="$(awk -F. '{$1++; $2=0; $3=0; print $1"."$2"."$3}' <<< "$tag_latest")";;
    *) bake.die "expected 'revision', 'patch', 'minor', 'major'. got '$type'"
  esac

  rockspec="$(<./lpresence-dev-1.rockspec)"
  rockspec="${rockspec//local version = '""'/local _version = \"$version_next\"}"
  rockspec="${rockspec//version = '"dev-1"'/version = _version}"
  rockspec="${rockspec//branch = '"main"'/branch = \"v\".._version}"

  git tag -a "v$version_next" -m "Release: v$version_next"
 
  [[ -n "$2" ]] && git push origin main --follow-tags
}
