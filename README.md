# proyecto-trivy

Laboratorio académico: **simulación de ataque a la cadena de suministro (Supply Chain Attack)** en CI/CD, caso de estudio **TeamPCP vs Aqua Security (Trivy)**.

Repositorio privado de práctica. No contiene malware real ni ataca infraestructura de terceros.

## Estructura

```text
proyecto-trivy/
├── .github/
│   └── workflows/
│       ├── trivy-demo.yml       # ATAQUE (workflow_dispatch + self-hosted)
│       └── verify-and-run.yml   # MITIGACIÓN (verificación SHA256)
├── trivy-demo-lab/
│   ├── Dockerfile               # Imagen FAKE-TRIVY (lab)
│   ├── steal_server.py          # C2 Flask (Kali)
│   ├── verify_image.sh          # Verificación local de digest
│   └── README.md
└── README.md
```

> Los workflows **deben** estar en `.github/workflows/` en la raíz. GitHub no detecta workflows dentro de subcarpetas como `trivy-demo-lab/`.

## Qué se demuestra

1. **Ataque:** un Self-Hosted Runner hace `docker pull` + `docker run` de una imagen que simula Trivy y exfiltra secretos **falsos** a un C2 en Kali.
2. **Detección:** agente Wazuh en el host Windows víctima.
3. **Mitigación:** el workflow *Secure Scan* compara digest SHA256; si no coincide → `FAIL` y el paso de ejecución queda `SKIPPED`.

## Cómo ejecutar (resumen)

### Prerrequisitos

- Red Host-Only: Kali `192.168.56.101`, Windows `192.168.56.1`, Wazuh `192.168.56.103`
- Docker en Windows (registry `0.0.0.0:5000`) + firewall “Registry Lab 5000”
- Self-Hosted Runner registrado (`self-hosted`, `Windows`, `X64`) — dejar `.\run.cmd` corriendo
- En Kali: `insecure-registries` → `192.168.56.1:5000`

### Orden

1. Wazuh: iniciar manager / indexer / dashboard  
2. Windows: registry + firewall + Wazuh agent + runner  
3. Kali T1: build/push `lab/trivy-demo:1.0`  
4. Kali T2: `python3 steal_server.py`  
5. Windows: `curl.exe http://192.168.56.101:8080`  
6. GitHub Actions → **Trivy Demo - Supply Chain Attack Simulation** → Run workflow  
7. Mitigación: obtener digest → **Secure Scan - Verify Image Integrity** (PASS / FAIL)

### Digest para pruebas

| Escenario | Valor |
|-----------|--------|
| PASS | `sha256:945deaa540bf041e248d56b856a403fba320a585736021dc5ca3c3a04b1d7dcd` |
| FAIL | `sha256:FAKE_DIGEST_1234567890abcdef1234567890abcdef1234567890abcdef` |

> El PASS debe tener **64** caracteres hex después de `sha256:`. Si rebuild-eas la imagen, vuelve a sacar el digest con `docker inspect`.

### Runner (Windows)

```powershell
cd "C:\WINDOWS\system32\actions-runner\actions-runner"
.\run.cmd
```

Usar **comillas** en la ruta (`\a` se interpreta como bell character).

## Relación con el incidente real

El caso real (marzo 2026) involucró `pull_request_target`, PAT robados, *tag repointing* en `trivy-action` y exfiltración avanzada.  
Este laboratorio **no replica ese vector exacto**: simula el **mismo principio** — artefacto confiable por tag + ejecución en CI + exfiltración + control de integridad por digest.

Detalle del lab: ver [`trivy-demo-lab/README.md`](trivy-demo-lab/README.md).

## Licencia / uso

Solo fines educativos. Credenciales ficticias. Entorno aislado.
