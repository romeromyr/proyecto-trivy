from flask import Flask, request
from datetime import datetime

app = Flask(__name__)


@app.route("/steal", methods=["POST"])
def steal():
    data = request.get_data(as_text=True)
    print("\n" + "=" * 55)
    print("ALERTA: DATOS EXFILTRADOS POR IMAGEN COMPROMETIDA")
    print("Fecha:", datetime.now())
    print("=" * 55)
    print(data if data else "[No se encontraron secretos]")
    return {"status": "received"}, 200


if __name__ == "__main__":
    print("Servidor de exfiltracion escuchando en http://0.0.0.0:8080")
    app.run(host="0.0.0.0", port=8080)
