#!/bin/bash
IMAGE=$1
EXPECTED_DIGEST=$2

echo "=========================================="
echo "VERIFICACION DE INTEGRIDAD - PIPELINE CI/CD"
echo "=========================================="
echo "[INFO] Imagen a verificar: $IMAGE"
echo "[INFO] Digest esperado:    $EXPECTED_DIGEST"

ACTUAL_DIGEST=$(sudo docker inspect $IMAGE --format='{{index .RepoDigests 0}}' 2>/dev/null)

echo "[INFO] Digest actual:      $ACTUAL_DIGEST"
echo "------------------------------------------"

if [ "$ACTUAL_DIGEST" == "$EXPECTED_DIGEST" ]; then
    echo "[PASS] DIGEST COINCIDE"
    echo "[PASS] Imagen verificada. Ejecucion permitida."
    exit 0
else
    echo "[FAIL] ALERTA: DIGEST NO COINCIDE"
    echo "[FAIL] La imagen puede haber sido alterada!"
    echo "[FAIL] Ejecucion BLOQUEADA."
    exit 1
fi
