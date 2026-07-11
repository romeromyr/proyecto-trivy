# trivy-demo-lab

Laboratorio académico controlado: simulación de **Supply Chain Attack** inspirado en el incidente TeamPCP / Aqua Security (Trivy), **sin atacar sistemas reales**.

## Qué simula

| Incidente real (2026) | Equivalente en este lab |
|-----------------------|-------------------------|
| Confianza en artefacto por tag mutable | Imagen `lab/trivy-demo:1.0` en registry local |
| Payload que se hace pasar por escáner | Script `fake-trivy.sh` dentro del contenedor |
| Exfiltración de secretos de CI/CD | Variables `fake_*` → POST a C2 Flask `:8080` |
| Mitigación: no confiar solo en tags | Verificación de digest SHA256 antes de ejecutar |

> **No** se explota `pull_request_target` ni se envenenan tags de GitHub públicos. El disparo del pipeline es `workflow_dispatch` sobre un **Self-Hosted Runner** Windows.

## Archivos

| Archivo | Uso |
|---------|-----|
| `Dockerfile` | Imagen maliciosa FAKE-TRIVY (lab) |
| `steal_server.py` | C2 Flask — ejecutar en Kali |
| `verify_image.sh` | Prueba local PASS/FAIL de digest (Kali) |

## Arquitectura validada

| Rol | Máquina | IP | Función |
|-----|---------|-----|---------|
| Atacante | Kali Linux | `192.168.56.101` (Host-Only) | Build/push, C2 `:8080` |
| Víctima | Windows | `192.168.56.1` | Registry `:5000`, Runner, Wazuh Agent |
| SIEM | Wazuh | `192.168.56.103` | Detección |
| Control | GitHub | `romeromyr/proyecto-trivy` | Workflows |

## Digest de referencia (lab original)

```text
sha256:945deaa540bf041e248d56b856a403fba320a585736021dc5ca3c3a04b1d7dcd
```

Obtener el digest actual:

```bash
sudo docker inspect 192.168.56.1:5000/lab/trivy-demo:1.0 --format='{{index .RepoDigests 0}}'
```

## Advertencia ética

Solo redes privadas / VMs propias. Credenciales **falsas** (`fake_*`). No usar tokens reales ni registries productivos.
