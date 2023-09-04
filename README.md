# arsentievvit_infra
arsentievvit Infra repository

# ДЗ №6

# Основная часть

- Опробован инструмент terraform
- Развёрнут образ reddit-base, подкинуты скрипты, всё работает

# Дополнительная часть

- Создана таргет группа для балансировщика
- Развёрнут HTTP балансировщик
- Через count указано создание 2 хостов
- При отключении сервиса видно, что меняется статус

В данном варианте, чтобы инстансы reddit-base закончили обновляться, им необходимо подключение во внешний
мир. То есть как минимум в первый раз необходимо запускать их с **nat = true**. \
Это можно пофиксить созданием nat инстанса, которым может выступить, наверное, bastion. И исходящий траффик от инстансов можно маршрутизировать во внешний мир. \
В этом случае в коннектор можно добавить параметры **bastion_host**, **bastion_port**, **bastion_user** и **bastion_private_key** и через bastion произойдет подключение к внутренним инстансам.
Другой вариант - сразу запечь готовое приложение, как было выполнено в ДЗ по packer. В таком случае никаких апдейтов ставить не надо. \
Балансировщик вполне прекрасно начнёт работу с инстансами во внутренней сети.

## Запуск

Заполнить **terraform.tfvars.example** своими значениями

```bash
# Переименование файла конфигурации
mv terraform.tfvars.examle terraform.tfvars

# Инициализация terraform
terraform init

# Планирование операций
terraform plan -var-file=terraform.tfvars

# Выполнение задания
terraform apply -var-file=terraform.tfvars
```

# ДЗ №5

## Основная часть

- Произошло знакомство с инструментом packer
- Выполнена сборка образа с добавлением нужных пакетов
- Доустановка приложения и проверка его работы

## Дополнительная часть

- Создан файл сборки immutable образа, в котором всё работает
- Создан скрипт запуска ВМ с последним образом из image-family

## Запуск
Для запуска потребуется настроенные 'yc'.

Для сборки образа необходимо заполнить файл 'variables.json' своими значениями:
```bash
mv variables.json.example variables.json
nano variables.json
```
Далее запустить сборщик:
```bash
packer build -var-file=variables.json immutable.pkr.hcl
```

После успешной отработки 'packer' переходим в директорию config-scripts \
и запускаем create-reddit-vm.sh.
```bash
cd config-scripts
./create-reddit-vm.sh
```

Проверяем в браузере http://IP:9292

# ДЗ №4

testapp_IP = 158.160.100.176
testapp_port = 9292

## Основная часть

- Опробован инструмент yc, с помощью него создан инстанс с заданными параметрами
- Установлены зависимости для redditapp, всё работает
- Созданы скрипты по отдельности для каждого из пунктов (Ruby, Mongodb, Git + bundle)
- Всё работает

## Дополнительная часть

Пришлось повозиться. Не знаю правильно ли я сделал но результат есть. \
В итоге собран общий startup.sh, который сам по себе на инстанс не отправляется. \
Вместо этого был написан userdata.yaml для cloud-init. Через модуль write_files, с указанным \
content ```base64 -i startup_script.sh -o /dev/sdtout``` \
на инстансе воссоздаётся тот самый startup.sh, который потом выполняется с помощью команды ```runcmd```.

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

createvm.sh
```
yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --metadata-from-file user-data=userdata.yaml
```
startup.sh
```
#!/bin/sh
sudo apt update -y && \
sudo apt install -y git mongodb ruby-full ruby-bundler build-essential

[ -e /usr/bin/mongo ] && sudo systemctl enable mongodb
sudo systemctl start mongodb

git clone -b monolith https://github.com/express42/reddit.git /home/yc-user/redditapp && \
cd /home/yc-user/redditapp
chown -R yc-user:yc-user /home/yc-user
[ -e /usr/bin/bundle ] && bundle install
su - yc-user -c "cd redditapp;puma -d"
sleep 10
IP=`curl 2ip.ru`
PORT=`ps aux | grep puma | grep -v grep | sed -n 's/.*:\([0-9]\+\).*/\1/p'`
echo "$IP:$PORT" > /home/yc-user/connect.txt
```

userdata.yaml
```
#cloud-config
datasource:
 Ec2:
  strict_id: false
ssh_pwauth: no
users:
- name: yc-user
  sudo: ALL=(ALL) NOPASSWD:ALL
  shell: /bin/bash
  ssh_authorized_keys:
  - {SSH_KEY}
write_files:
- encoding: b64
  content: {base64 of startup.sh}
  owner: yc-user:yc-user
  path: /home/yc-user/startup.sh
  permissions: '0755'
runcmd:
  [ sh, /home/yc-user/startup.sh ]
```

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

bastion_IP = 158.160.117.90
someinternalhost_IP = 10.128.0.28
