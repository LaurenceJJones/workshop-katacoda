#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  attack-emulator ssh-bruteforce [target] [user] [attempts]
  attack-emulator web-scan [url]

Examples:
  attack-emulator ssh-bruteforce controlplane admin 26
  attack-emulator web-scan http://controlplane
EOF
}

ssh_bruteforce() {
  local target="${1:-controlplane}"
  local user="${2:-admin}"
  local attempts="${3:-26}"
  local askpass
  local i=0

  askpass="$(mktemp)"
  trap 'rm -f "$askpass"' EXIT

  cat >"$askpass" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "${ATTACK_PASSWORD:-invalid}"
EOF
  chmod 700 "$askpass"

  while [ "$i" -lt "$attempts" ]; do
    local password
    password="$(printf "\\$(printf '%03o' $((97 + (i % 26))))")"
    ATTACK_PASSWORD="$password" \
      DISPLAY=:0 \
      SSH_ASKPASS="$askpass" \
      SSH_ASKPASS_REQUIRE=force \
      setsid -w ssh \
        -o ConnectTimeout=2 \
        -o NumberOfPasswordPrompts=1 \
        -o PreferredAuthentications=password \
        -o PubkeyAuthentication=no \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "${user}@${target}" "exit" \
        </dev/null >/dev/null 2>&1 || true
    i=$((i + 1))
  done

  echo "Completed ${i} failed SSH authentication attempts against ${user}@${target}"
}

web_scan() {
  local base_url="${1:-http://controlplane}"
  local -a paths=(
    "/"
    "/admin"
    "/phpinfo.php"
    "/server-status"
    "/.env"
    "/.git/config"
    "/?id=1%20OR%201=1--"
    "/?q=%3Cscript%3Ealert(1)%3C/script%3E"
    "/index.php?page=../../../../etc/passwd"
  )
  local path

  for path in "${paths[@]}"; do
    curl -ksS -A "AttackEmulator/1.0" -o /dev/null "${base_url%/}${path}" || true
  done

  echo "Completed web scan emulation against ${base_url}"
}

main() {
  local mode="${1:-}"
  shift || true

  case "$mode" in
    ssh-bruteforce)
      ssh_bruteforce "$@"
      ;;
    web-scan)
      web_scan "$@"
      ;;
    *)
      usage
      exit 1
      ;;
  esac
}

main "$@"
