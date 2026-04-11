# app.py — простой Flask веб-сервис
# Это "web-сервис из темы №2", подключаемый за префиксом /app

# Flask — минималистичный веб-фреймворк для Python.
# pip install flask устанавливает его.
from flask import Flask, jsonify, request
import os
import socket

# Создаём экземпляр Flask-приложения
# __name__ — имя текущего модуля (используется Flask для поиска шаблонов)
app = Flask(__name__)


# @app.route — декоратор, который говорит Flask:
# "при GET-запросе на '/' вызови функцию index()"
@app.route('/')
def index():
    """Главная страница сервиса."""
    # Возвращаем HTML-страницу
    return """
    <html>
    <head>
        <title>Python Web Service</title>
        <style>
            body { font-family: Arial, sans-serif; max-width: 600px; margin: 50px auto; padding: 20px; }
            h1 { color: #2c3e50; }
            .info { background: #ecf0f1; padding: 15px; border-radius: 8px; margin: 10px 0; }
            code { background: #ddd; padding: 2px 6px; border-radius: 3px; }
        </style>
    </head>
    <body>
        <h1>Python Web Service</h1>
        <div class="info">
            <p>Сервис работает за Traefik по префиксу <code>/app</code></p>
            <p>Попробуйте: <a href="/info">/info</a></p>
        </div>
    </body>
    </html>
    """


@app.route('/info')
def info():
    """Возвращает JSON с информацией о сервисе."""
    return jsonify({
        # Имя хоста контейнера (Docker ID)
        "hostname": socket.gethostname(),
        # Путь запроса (будет '/' если middleware убрал /app)
        "request_path": request.path,
        # Заголовки запроса
        "host_header": request.headers.get("Host", ""),
        # Переменные окружения Flask
        "flask_env": os.environ.get("FLASK_ENV", "development"),
        "message": "Привет от Python Flask!"
    })


@app.route('/health')
def health():
    """Эндпоинт для проверки работоспособности (healthcheck)."""
    return jsonify({"status": "ok"}), 200


# Запускаем приложение:
# host='0.0.0.0' — слушаем на всех интерфейсах (нужно для Docker)
# port=5000 — стандартный порт Flask
# debug=False — в продакшне дебаг должен быть выключен
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)