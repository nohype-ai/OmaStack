#!/bin/bash
# Install or replace ~/.local/bin/omack. Does not need a git checkout.
# ~/.config/omastack/config.toml is created if missing and is never overwritten.
# Then `omack init` asks for the stack folder if needed and creates
# wanted.txt and unwanted.txt there. Existing lists are left unchanged.
#
#   curl -fsSL https://omastack.dev/install.sh | bash
#
#   ./install.sh
#     Install omack from this checkout when run as a file next to omack.
#   ./install.sh --dev
#     Same, but fail if that local omack is missing.
set -euo pipefail

if [[ "${1:-}" == "--dev" ]]; then
  DEV=1
elif [[ -n "${1:-}" ]]; then
  echo "usage: install.sh [--dev]" >&2
  exit 1
else
  DEV=0
fi

REPO="${OMACK_REPO:-nohype-ai/OmaStack}"
REF="${OMACK_REF:-main}"
URL="${OMACK_URL:-https://raw.githubusercontent.com/${REPO}/${REF}/omack}"
DEST="${HOME}/.local/bin/omack"
DIR="${XDG_CONFIG_HOME:-$HOME/.config}/omastack"

HERE=""
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
  HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

echo "OmaStack installer"
echo "  dest  $DEST"

src=""
if [[ "$DEV" -eq 1 ]]; then
  if [[ -z "${HERE:-}" ]]; then
    echo "error: --dev must be run as a file from the OmaStack repo" >&2
    exit 1
  fi
  src="$HERE/omack"
  if [[ ! -f "$src" ]]; then
    echo "error: missing $src" >&2
    exit 1
  fi
  echo "  from  $src (--dev)"
elif [[ -n "${HERE:-}" && -f "$HERE/omack" && -z "${OMACK_URL:-}" ]]; then
  src="$HERE/omack"
  echo "  from  $src (checkout)"
else
  echo "  from  $URL"
  src="$(mktemp)"
  trap 'rm -f "$src"' EXIT
  curl -fsSL "$URL" -o "$src"
  chmod 755 "$src"
fi

mkdir -p "$(dirname "$DEST")"
install -D -m 755 "$src" "$DEST"

mkdir -p "$DIR"
if [[ ! -e "$DIR/config.toml" ]]; then
  printf '%s\n' '# omack writes stack_path here.' > "$DIR/config.toml"
  echo "  config $DIR/config.toml"
else
  echo "  keep  $DIR/config.toml"
fi

# Never pass --force. A later install updates omack and leaves edited lists alone.
echo "  init  $DEST init"
init_err="$(mktemp)"
set +e
"$DEST" init 2>"$init_err"
init_rc=$?
set -e
if [[ "$init_rc" -eq 0 ]]; then
  cat "$init_err" >&2
elif [[ "$init_rc" -eq 2 ]]; then
  echo "  keep  stack lists unchanged"
else
  cat "$init_err" >&2
  rm -f "$init_err"
  exit "$init_rc"
fi
rm -f "$init_err"

echo "  ok    $($DEST version)"
