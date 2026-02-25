import requests
import sys
import os

URL = os.getenv("APP_URL")

if not URL:
    print("variavel APP_URL nao definida")
    sys.exit(1)

try:
    response = requests.get(URL, timeout=5)

    if response.status_code == 200:
        print(f"OK - {URL} respondeu 200")
        sys.exit(0)
    else:
        print(f"FAIL - {URL} respondeu {response.status_code}")
        sys.exit(1)

except requests.exceptions.RequestException as e:
    print(f"ERRO ao acessar {URL}: {e}")
    sys.exit(1)
