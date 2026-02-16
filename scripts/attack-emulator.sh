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
  cleanup() {
    rm -f "$askpass"
  }
  handle_signal() {
    echo "SSH bruteforce emulation interrupted by $1" >&2
    exit "$2"
  }
  trap cleanup EXIT
  trap 'handle_signal SIGINT 130' SIGINT
  trap 'handle_signal SIGTERM 143' SIGTERM
  trap 'handle_signal SIGTRAP 133' SIGTRAP

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
  local admin_list_url="https://raw.githubusercontent.com/crowdsecurity/sec-lists/master/web/admin_interfaces.txt"
  local -a paths=()
  local path

  mapfile -t paths < <(
    curl -fsSL "$admin_list_url" 2>/dev/null | sed -e 's/\r$//' -e '/^[[:space:]]*#/d' -e '/^[[:space:]]*$/d'
  ) || true
  if [ "${#paths[@]}" -eq 0 ]; then
    paths=(
      "/admin"
      "/manager"
      "/phpmyadmin"
      "/pma"
      "/wp-admin"
      "/wp-login"
      "/phpinfo"
      "/boaform/"
      "/kcfinder/upload.php"
      "/+cscoe+/"
      "/dana-na/"
      "/repeater.php"
      "/sitecore/admin/login.aspx"
      "/sitecore/login/default.aspx"
      "/sitecore/admin/cache.aspx"
      "/solr/"
      "/sphider/admin/admin.php"
      "/sitefinity/authenticate/swt"
      "/scriptcase/devel/iface/"
      "/scriptcase/prod/lib/php/"
      "/web/database/manager"
      "/sfmc/login"
      "/dms/out/out.login.php"
      "/rsso/admin/"
      "/admin/login_uid.php"
      "/remote/login"
      "/commandcenter/restservlet/"
    )
  fi

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
