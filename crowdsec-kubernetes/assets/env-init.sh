#!/bin/bash

# install helm
curl -LO https://get.helm.sh/helm-v3.17.0-linux-amd64.tar.gz
tar -zxvf helm-v3.17.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/
rm -rf linux-amd64 helm-v3.17.0-linux-amd64.tar.gz linux-amd64

# Install attack emulator for attacker demo
cat > /usr/local/bin/attack-emulator <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
mode="${1:-}"
shift || true

case "$mode" in
  ssh-bruteforce)
    target="${1:-controlplane}"
    user="${2:-admin}"
    attempts="${3:-26}"
    askpass="$(mktemp)"
    trap 'rm -f "$askpass"' EXIT
    cat >"$askpass" <<'AP'
#!/usr/bin/env bash
printf '%s\n' "${ATTACK_PASSWORD:-invalid}"
AP
    chmod 700 "$askpass"
    i=0
    while [ "$i" -lt "$attempts" ]; do
      password="$(printf "\\$(printf '%03o' $((97 + (i % 26))))")"
      ATTACK_PASSWORD="$password" DISPLAY=:0 SSH_ASKPASS="$askpass" SSH_ASKPASS_REQUIRE=force \
      setsid -w ssh -o ConnectTimeout=2 -o NumberOfPasswordPrompts=1 -o PreferredAuthentications=password \
      -o PubkeyAuthentication=no -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
      "${user}@${target}" exit </dev/null >/dev/null 2>&1 || true
      i=$((i + 1))
    done
    echo "Completed $i failed SSH authentication attempts against ${user}@${target}"
    ;;
  web-scan)
    base_url="${1:-http://controlplane}"
    for path in / /admin /phpinfo.php /server-status /.env /.git/config '/?id=1%20OR%201=1--' '/?q=%3Cscript%3Ealert(1)%3C/script%3E' '/index.php?page=../../../../etc/passwd'; do
      curl -ksS -A "AttackEmulator/1.0" -o /dev/null "${base_url%/}${path}" || true
    done
    echo "Completed web scan emulation against ${base_url}"
    ;;
  *)
    echo "Usage: attack-emulator ssh-bruteforce [target] [user] [attempts] | web-scan [url]" >&2
    exit 1
    ;;
esac
EOF
chmod +x /usr/local/bin/attack-emulator
