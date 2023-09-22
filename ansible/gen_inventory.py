#!/usr/bin/env python3


# Для работы нужно установить модуль request
# Если он отсутствует

import json
import requests

# Инициализируемся в "yc", вводим "yc config list"
# Вставляем в FOLDERID свой folder-id из вывода
# Вывод yc iam create-token вставляем в IAMKEY
# PS токены валидны в течении 12 часов

FOLDERID = ""
IAMKEY = ""


# В качестве заголовков заявляем, что хотим json и даём инфу об авторизации
HEADERS = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': f'Bearer {IAMKEY}'
}

# Задаём id каталога, в котором необходимо выполнить запрос
PARAMETERS = {
    'folderId': {FOLDERID}
}

# URL обращения
GET_URL="https://compute.api.cloud.yandex.net/compute/v1/instances"

# Запрос к URL, используя заголовки и передаваемые параметры
# Кодируем в json
data = requests.get(url=GET_URL, headers=HEADERS, params=PARAMETERS).json()
# Инициализируем первую часть шаблона инвентаря
vars = {
    "_meta": {
        "hostvars": {}
    }
}

# Парсим JSON
# В объекте instances проходим по каждому элементу массива
for instance in data['instances']:
    # Начинаем заполнять шаблон
    vars['_meta']['hostvars'].update(
        {
            # Имя инстанса, внутри
            instance['name']: {
                # IP адрес инстанса
                'ansible_host': instance["networkInterfaces"][0]["primaryV4Address"]['oneToOneNat']["address"],
                # Тэг инстанса
                'instance_tag': instance["labels"]["tags"]
                # 'instance_name': instance["name"]
            }
        }
    )
# Вторая часть инвентаря, содержащая описание групп.
# Сначала описываем группу all, где будут все группы в объекте children
# Заполняем шаблон
group = {
    'all': {
        "children": [
            'app',
            'db',
            'stage',
            'prod'
        ]
    },
    'app': {
        "hosts": []
    },
    'db': {
        "hosts": []
    },
    'stage': {
        "hosts": []
    },
    'prod': {
        "hosts": []
    }
}

# Пробегаемся уже по созданным хостам в __meta
# Ищем по именам хостов, наполняем по именам шаблонов

for hostname in vars['_meta']['hostvars'].keys():
    if 'stage' in hostname:
        group['stage']['hosts'].append(hostname)
for hostname in vars['_meta']['hostvars'].keys():
    if 'prod' in hostname:
        group['prod']['hosts'].append(hostname)
for hostname in vars['_meta']['hostvars'].keys():
    if 'reddit-db' in hostname:
        group['db']['hosts'].append(hostname)
for hostname in vars['_meta']['hostvars'].keys():
    if 'reddit-app' in hostname:
        group['app']['hosts'].append(hostname)

# Инициализируем пустой инвентарь, добавляем в него оба заполненных элемента,
# Выводим в печать для ansible
inventory = {}
inventory.update(vars)
inventory.update(group)
print(json.dumps(inventory, indent=4))
