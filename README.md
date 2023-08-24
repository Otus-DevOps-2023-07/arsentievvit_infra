# arsentievvit_infra
arsentievvit Infra repository

# ДЗ №3

- Создан аккаунт в Яндекс.Облаке
- Создана ключевая пара для appuser
- Созданы две ВМ bastion и someinternalhost, подкинуты ключи
- Опробованы варианты подключения через SSH, OpenVPN к хосту someinternalhost
- Получен сертификат на Pritunl

## Для доступа к хосту внутренней сети одной командой

Без исправления конфигов:
```
ssh -J appuser@<IP> appuser@someinternalhost
```

## Если пошаманить
Для доступа с помощью команды ``` ssh someinternalhost ``` потребовалось поправить ~/.ssh/config:


```Bash
vim ~/.ssh/config

Host bastion
     HostName <IP>
     User appuser
     IdentityFile ~/.ssh/appuser

Host someinternalhost
     ProxyJump bastion
     User appuser
     IdentityFile ~/.ssh/appuser
```

На nip.io рейт лимит, воспользовался sslip.io \
Адрес: https://vpn-158-160-117-90.sslip.io

bastion_IP = 158.160.117.90 \
someinternalhost_IP = 10.128.0.28

#ДЗ 4

## Основная часть

- Опробован инструмент yc, с помощью него создан инстанс с заданными параметрами
- Установлены зависимости для redditapp, всё работает
- Созданы скрипты по отдельности для каждого из пунктов (Ruby, Mongodb, Git + bundle)
- Всё работает

## Дополнительная часть

Пришлось повозиться. Не знаю правильно ли я сделал но результат есть. \
В итоге собран общий startup_script.sh, который сам по себе на инстанс не отправляется. \
Вместо этого был написан userdata.yaml для cloud-init. Через модуль write_files, с указанным \
content ```base64 -i startup_script.sh -o /dev/sdtout``` \
на инстансе воссоздаётся тот самый startup_script.sh, который потом выполняется с помощью команды ```runcmd```.

## Как запустить

- Так как сам скрипт закодирован в base64 в userdata.yaml - лучше его раскодировать и просмотреть на всякий случай:)
- Инициализируем ```yc``` на локальной машине
- Клонируем ветку
```git clone -b cloud-testapp https://github.com/Otus-DevOps-2023-07/arsentievvit_infra.git```
- Копируем свой публичный ssh ключ, например id_rsa.pub
```cat ~/.ssh/id_rsa.pub```
- Вставляем этот ключ в userdata.yaml  после строки ssh_authorized_keys:.
- Запускаем createvm.sh. В результате будет создан инстанс, в котором userdata.yaml подброшен для cloud-init.
- Ждем минуты 3-4
- Проверяем доступность по IP с портом 9292

testapp_IP = 158.160.100.176 testapp_port = 9292
