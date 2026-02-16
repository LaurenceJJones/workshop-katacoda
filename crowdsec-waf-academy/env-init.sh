#!/bin/bash
# Install nginx service for CrowdSec auto detection
ssh root@host01 "echo 'githubciXXXXXXXXXXXXXXXXXXXXXXXX' > /etc/machine-id && apt update && apt install nginx -y"

# Install attack emulator for attacker demo
ssh root@node01 "cat > /usr/local/bin/attack-emulator <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
mode=\"\${1:-}\"
shift || true

case \"\$mode\" in
  ssh-bruteforce)
    target=\"\${1:-controlplane}\"
    user=\"\${2:-admin}\"
    attempts=\"\${3:-26}\"
    askpass=\"\$(mktemp)\"
    cleanup() {
      rm -f \"\$askpass\"
    }
    handle_signal() {
      echo \"SSH bruteforce emulation interrupted by \$1\" >&2
      exit \"\$2\"
    }
    trap cleanup EXIT
    trap 'handle_signal SIGINT 130' SIGINT
    trap 'handle_signal SIGTERM 143' SIGTERM
    trap 'handle_signal SIGTRAP 133' SIGTRAP
    cat >\"\$askpass\" <<'AP'
#!/usr/bin/env bash
printf '%s\n' \"\${ATTACK_PASSWORD:-invalid}\"
AP
    chmod 700 \"\$askpass\"
    i=0
    while [ \"\$i\" -lt \"\$attempts\" ]; do
      password=\"\$(printf \"\\\\\$(printf '%03o' \$((97 + (i % 26))))\")\"
      ATTACK_PASSWORD=\"\$password\" DISPLAY=:0 SSH_ASKPASS=\"\$askpass\" SSH_ASKPASS_REQUIRE=force \
      setsid -w ssh -o ConnectTimeout=2 -o NumberOfPasswordPrompts=1 -o PreferredAuthentications=password \
      -o PubkeyAuthentication=no -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
      \"\${user}@\${target}\" exit </dev/null >/dev/null 2>&1 || true
      i=\$((i + 1))
    done
    echo \"Completed \$i failed SSH authentication attempts against \${user}@\${target}\"
    ;;
  web-scan)
    base_url=\"\${1:-http://controlplane}\"
    admin_list_url=\"https://raw.githubusercontent.com/crowdsecurity/sec-lists/master/web/admin_interfaces.txt\"
    paths=()
    mapfile -t paths < <(
      curl -fsSL \"\$admin_list_url\" 2>/dev/null | sed -e 's/\\r$//' -e '/^[[:space:]]*#/d' -e '/^[[:space:]]*$/d'
    ) || true
    if [ \"\${#paths[@]}\" -eq 0 ]; then
      paths=(
        \"/admin\"
        \"/manager\"
        \"/phpmyadmin\"
        \"/pma\"
        \"/wp-admin\"
        \"/wp-login\"
        \"/phpinfo\"
        \"/boaform/\"
        \"/kcfinder/upload.php\"
        \"/+cscoe+/\"
        \"/dana-na/\"
        \"/repeater.php\"
        \"/sitecore/admin/login.aspx\"
        \"/sitecore/login/default.aspx\"
        \"/sitecore/admin/cache.aspx\"
        \"/solr/\"
        \"/sphider/admin/admin.php\"
        \"/sitefinity/authenticate/swt\"
        \"/scriptcase/devel/iface/\"
        \"/scriptcase/prod/lib/php/\"
        \"/web/database/manager\"
        \"/sfmc/login\"
        \"/dms/out/out.login.php\"
        \"/rsso/admin/\"
        \"/admin/login_uid.php\"
        \"/remote/login\"
        \"/commandcenter/restservlet/\"
      )
    fi
    for path in \"\${paths[@]}\"; do
      curl -ksS -A \"AttackEmulator/1.0\" -o /dev/null \"\${base_url%/}\${path}\" || true
    done
    echo \"Completed web scan emulation against \${base_url}\"
    ;;
  *)
    echo \"Usage: attack-emulator ssh-bruteforce [target] [user] [attempts] | web-scan [url]\" >&2
    exit 1
    ;;
esac
EOF
chmod +x /usr/local/bin/attack-emulator"

apt install nginx -y && sed -i 's/try_files $uri $uri\/ \=404\;/proxy_pass http:\/\/127.0.0.1:8080\;/' /etc/nginx/sites-enabled/default
