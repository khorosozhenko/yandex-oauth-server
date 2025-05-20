import os
from flask import Flask, request
import requests

app = Flask(__name__)

# Секретные данные из переменных окружения Render
CLIENT_ID = os.environ.get("YANDEX_CLIENT_ID")
CLIENT_SECRET = os.environ.get("YANDEX_CLIENT_SECRET")

@app.route("/")
def home():
    return "Сервер работает!"

@app.route("/oauth")
def oauth_callback():
    code = request.args.get('code')
    state = request.args.get('state')  # Здесь у тебя chat_id Telegram

    if not code or not state:
        return "Ошибка: отсутствует code или state."

    # Обмениваем code на токен
    token_url = "https://oauth.yandex.ru/token"
    data = {
        "grant_type": "authorization_code",
        "code": code,
        "client_id": CLIENT_ID,
        "client_secret": CLIENT_SECRET,
    }
    resp = requests.post(token_url, data=data)
    if resp.status_code != 200:
        return f"Ошибка при получении токена: {resp.text}"

    token_data = resp.json()
    access_token = token_data.get("access_token")
    refresh_token = token_data.get("refresh_token")

    # Здесь нужно сохранить токены и chat_id, например, в Google Таблицу

    # (Здесь можно уведомить пользователя через Telegram, что всё прошло успешно)

    return "Авторизация завершена! Теперь можете вернуться в Telegram-бота."

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000)
