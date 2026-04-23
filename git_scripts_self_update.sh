#!/usr/bin/env bash

git_scripts_is_truthy() {
  case "${1,,}" in
    1|true|yes|y|on) return 0 ;;
  esac
  return 1
}

git_scripts_run_update_fetch_with_timeout() {
  local repo="$1"
  local branch="$2"
  local timeout_seconds="${GIT_SCRIPTS_UPDATE_FETCH_TIMEOUT_SECONDS:-2}"

  if command -v timeout >/dev/null 2>&1; then
    timeout "$timeout_seconds" git -C "$repo" fetch origin "$branch" >/dev/null 2>&1
    local status=$?
    [ "$status" -eq 124 ] && return 1
    return "$status"
  fi

  git -C "$repo" fetch origin "$branch" >/dev/null 2>&1
}

git_scripts_repo_is_behind_remote() {
  local repo="$1"
  local local_ref="$2"
  local remote_ref="$3"

  git -C "$repo" rev-parse --verify "$local_ref" >/dev/null 2>&1 || return 1
  git -C "$repo" rev-parse --verify "$remote_ref" >/dev/null 2>&1 || return 1

  if git -C "$repo" merge-base --is-ancestor "$local_ref" "$remote_ref"; then
    [ "$(git -C "$repo" rev-parse "$local_ref")" != "$(git -C "$repo" rev-parse "$remote_ref")" ]
    return $?
  fi

  return 1
}

git_scripts_resolve_repo_root() {
  if [ -n "${GIT_SCRIPTS_REPO_ROOT:-}" ]; then
    printf '%s\n' "$GIT_SCRIPTS_REPO_ROOT"
    return 0
  fi

  if [ -n "${BASH_SOURCE[0]:-}" ]; then
    local source_dir=""
    source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
    if git -C "$source_dir" rev-parse --show-toplevel >/dev/null 2>&1; then
      git -C "$source_dir" rev-parse --show-toplevel
      return 0
    fi
  fi

  if git rev-parse --show-toplevel >/dev/null 2>&1; then
    git rev-parse --show-toplevel
    return 0
  fi

  return 1
}

git_scripts_maybe_self_update() {
  [ "${GIT_SCRIPTS_UPDATE_CHECK:-1}" != "0" ] || return 0
  [ "${GIT_SCRIPTS_UPDATE_ALREADY_CHECKED:-0}" = "1" ] && return 0
  export GIT_SCRIPTS_UPDATE_ALREADY_CHECKED=1

  local repo=""
  repo="$(git_scripts_resolve_repo_root)" || return 0

  local git_dir=""
  git_dir="$(git -C "$repo" rev-parse --git-dir 2>/dev/null || true)"
  [ -n "$git_dir" ] || return 0

  local cache_path="$git_dir/git_scripts_update_check"
  local now=""
  now="$(date +%s)"
  local interval_seconds="${GIT_SCRIPTS_UPDATE_CHECK_INTERVAL_SECONDS:-21600}"

  if [ -f "$cache_path" ]; then
    local checked_at=""
    checked_at="$(head -n 1 "$cache_path" 2>/dev/null || true)"
    if [[ "$checked_at" =~ ^[0-9]+$ ]] && [ $((now - checked_at)) -lt "$interval_seconds" ]; then
      return 0
    fi
  fi

  local branch=""
  branch="$(git -C "$repo" branch --show-current 2>/dev/null || true)"
  [ -n "$branch" ] || branch="main"

  git_scripts_run_update_fetch_with_timeout "$repo" "$branch" || return 0
  printf '%s\n' "$now" > "$cache_path" 2>/dev/null || true

  if ! git_scripts_repo_is_behind_remote "$repo" "HEAD" "origin/$branch"; then
    return 0
  fi

  if [ ! -t 0 ] || [ ! -t 1 ]; then
    echo "[git_scripts] A newer version is available."
    return 0
  fi

  printf "[git_scripts] A newer version is available. Would you like to update now? [y/N] "
  local response=""
  read -r response || true
  if ! git_scripts_is_truthy "${response:-n}"; then
    echo "[git_scripts] Update skipped."
    return 0
  fi

  git -C "$repo" fetch origin "$branch"
  if git -C "$repo" pull --ff-only origin "$branch"; then
    echo "[git_scripts] Updated successfully."
    if [ "$#" -gt 0 ]; then
      echo "[git_scripts] Restarting command with the updated version."
      exec "$@"
    fi
    return 0
  fi

  echo "[git_scripts] Automatic update failed. Run 'git -C $repo pull --ff-only origin $branch' manually."
  return 0
}
