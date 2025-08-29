#!/bin/bash
apt install curl jq dnsutils -y >/dev/null 2>&1
if ! command -v dig >/dev/null 2>&1; then
  echo "❌ DNS utils installation failed"
  exit 1
fi

get_public_ip() {
  local ip
  ip=$(wget -qO- ipv4.icanhazip.com 2>/dev/null || \
       curl -s ifconfig.me 2>/dev/null || \
       curl -s https://api.ipify.org 2>/dev/null)
  echo "$ip"
}

MYIP=$(get_public_ip)
DOMAIN="unspecified"
CF_ID="changeme@example.com"
CF_KEY="changeme"
generate_subdomain() {
  echo "$(tr -dc a-z0-9 </dev/urandom | head -c5).${DOMAIN}"
}

check_subdomain_exists() {
  local subdomain="$1"
  local zone_id=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r '.result[0].id')
  RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records?name=${subdomain}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r '.result[0].id')
}

RECORD_ID=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records?name=${subdomain}" \
   -H "X-Auth-Email: ${CF_ID}" \
   -H "X-Auth-Key: ${CF_KEY}" \
   -H "Content-Type: application/json" | jq -r '.result[0].id')

if [[ "${#RECORD_ID}" -gt 10 ]]; then
  wait_for_propagation() {
    local domain="$1"
    echo "===================="
    echo "🌐 VPN Subdomain: ${domain}"
    echo "===================="
    echo "Activating subdomain.."
    local dns_server_ip=$(get_public_ip)
    local elapsed=0
    local max_wait=40
    while [ $elapsed -lt $max_wait ]; do
      local resolved=$(dig +short "${domain}" @8.8.8.8)
      if [ "${resolved}" = "${dns_server_ip}" ]; then
        echo "✅ Subdomain activated successfully!"
        echo "🔒 Ready for SSL certificate verification and installation"
        return 0
      fi
      sleep 5
      elapsed=$((elapsed + 5))
    done
    echo "❌ Subdomain configuration failed after 40 seconds wait"
    return 1
  }

  echo "  Configuring DNS records..."
  sleep 5
  wait_for_propagation "${subdomain}" || {
    echo "❌ Domain Configuration error"
    exit 1
  }
else
  attempts=0
  sub=$(get_public_ip)
  if ! check_subdomain_exists "${sub}"; then
    break
  fi
  attempts=$((attempts + 1))
  if [ $attempts -gt 10 ]; then
    echo "❌ Unable to generate unique subdomain"
    exit 1
  fi
fi

echo "Getting new subdomain..."
DNS_RESPONSE=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records" \
   -H "X-Auth-Email: ${CF_ID}" \
   -H "X-Auth-Key: ${CF_KEY}" \
   -H "Content-Type: application/json" \
   --data "{\"type\":\"A\",\"name\":\"${MYIP}\",\"content\":\"${MYIP}\",\"ttl\":120,\"proxied\":false}" \
   > /root/${DOMAIN})

SUCCESS=$(echo "${DNS_RESPONSE}" | jq -r '.success' >/dev/null)
if [ "${SUCCESS}" = "true" ]]; then
  echo "✅ DNS record created successfully"
else
  echo "❌ DNS record creation failed"
  exit 1
fi

echo "${sub}" > /etc/xray/${DOMAIN}
echo "${sub}" > /etc/xray/scdomain
echo "${sub}" > /etc/xray/domain
echo "IP=$sub" > /var/lib/ky/vps.conf

wait_for_propagation
echo "📝 Subdomain ready: ${sub}"
echo
exit 0

