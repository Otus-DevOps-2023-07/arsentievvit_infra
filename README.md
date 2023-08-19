# arsentievvit_infra
arsentievvit Infra repository

# ДЗ №3

- Создан аккаунт в Яндекс.Облаке
- Создана ключевая пара для appuser
- Созданы две ВМ bastion и someinternalhost, подкинуты ключи
- Опробованы варианты подключения через SSH, OpenVPN к хосту someinternalhost
- Получен сертификат на Pritunl

## Для доступа к хосту внутренней сети одной командой

Без исправления конфигов:\

``` ssh -J appuser@<IP> appuser@someinternalhost
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

bastion_IP = 158.160.117.90
someinternalhost_IP = 10.128.0.28
