#!/usr/bin/env bash
# One-line install:
#   curl -fsSL https://raw.githubusercontent.com/Micuks/claudex/main/install.sh | bash
#
# Options (env):
#   CLAUDEX_PREFIX=$HOME/.local        install prefix
#   CLAUDEX_REPO=Micuks/claudex        GitHub repo
#   CLAUDEX_REF=main                   branch/tag/commit
#   CLIPROXY_VERSION=v7.2.93           pin CLIProxyAPI release (or "latest")
#   CLAUDEX_SKIP_CLIPROXY=1            only install the wrapper script
#   CLAUDEX_NO_PATH_HINT=1             suppress PATH hint

set -euo pipefail

CLAUDEX_REPO="${CLAUDEX_REPO:-Micuks/claudex}"
CLAUDEX_REF="${CLAUDEX_REF:-main}"
CLAUDEX_PREFIX="${CLAUDEX_PREFIX:-$HOME/.local}"
BIN_DIR="${CLAUDEX_PREFIX}/bin"
RAW_BASE="https://raw.githubusercontent.com/${CLAUDEX_REPO}/${CLAUDEX_REF}"

info() { printf 'claudex-install: %s\n' "$*" >&2; }
die() { printf 'claudex-install: %s\n' "$*" >&2; exit 1; }

have() { command -v "$1" >/dev/null 2>&1; }

download() {
  local url="$1" dest="$2"
  if have curl; then
    curl -fsSL -o "$dest" "$url"
  elif have wget; then
    wget -qO "$dest" "$url"
  else
    die "need curl or wget"
  fi
}

main() {
  mkdir -p "$BIN_DIR"
  local tmp
  tmp="$(mktemp)"
  # shellcheck disable=SC2064
  trap "rm -f '$tmp'" EXIT

  info "fetching claudex from ${CLAUDEX_REPO}@${CLAUDEX_REF}..."
  download "${RAW_BASE}/bin/claudex" "$tmp"
  # basic sanity
  head -1 "$tmp" | grep -q 'bash\|sh' || die "downloaded file does not look like a shell script"
  install -m 0755 "$tmp" "${BIN_DIR}/claudex"
  info "installed ${BIN_DIR}/claudex"

  case ":$PATH:" in
    *":${BIN_DIR}:"*) ;;
    *)
      if [[ -z "${CLAUDEX_NO_PATH_HINT:-}" ]]; then
        info "add to your shell rc:"
        info "  export PATH=\"${BIN_DIR}:\$PATH\""
      fi
      export PATH="${BIN_DIR}:$PATH"
      ;;
  esac

  if [[ -z "${CLAUDEX_SKIP_CLIPROXY:-}" ]]; then
    info "running: claudex setup"
    "${BIN_DIR}/claudex" setup
  fi

  cat <<EOF

claudex installed.

Next steps:
  1) Ensure Claude Code is available:
       npm i -g @anthropic-ai/claude-code
  2) Authenticate Codex (pick one):
       claudex login
       claudex login --device
       claudex import-auth          # if you already have ~/.codex/auth.json
  3) Launch:
       claudex
       claudex doctor

EOF
}

main "$@"
