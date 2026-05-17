#!/usr/bin/env bash
ip="$1"

if [ -z "$ip" ];then
  echo "Uso: $0 <IP>"
  exit 1
fi

echo "Escaneando todos los puertos en $ip..."
for port in {1..65535};do
  timeout 0.3 bash -c "echo > /dev/tcp/$ip/$port" 2>/dev/null
  if [ $? -eq 0 ];then
    echo "[+] Puerto $port abierto"
  fi
done
