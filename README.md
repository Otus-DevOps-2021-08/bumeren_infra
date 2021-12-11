# bumeren_infra
bumeren Infra repository

# Самостоятельное задание
# Способ подключения к someinternalhost в одну команду из вашего рабочего
# устройства
ssh-add ~/.ssh/appuser; ssh -o BatchMode=yes -o StrictHostKeyChecking=no \
-A -q -tt appuser@62.84.117.242 ssh 10.128.0.35

# Дополнительное задание
# Предложить вариант решения для подключения из консоли при помощи команды
# ssh someinternalhost из локальной консоли рабочего устройства, чтобы под-
# ключение выполнялось по алиасу someinernalhost
# Добавляем на локальной машине в file ~/.ssh/config
Host bastion
   Hostname 62.84.117.242
   User appuser
   Port 22
   IdentityFile ~/.ssh/appuser
   ControlPath ~/.ssh/cm-%r@%h:%p
   ControlMaster auto
   ControlPersist 1m
   StrictHostKeyChecking no

Host someinternalhost
   Hostname 10.128.0.35
   User appuser
   Port 22
   IdentityFile ~/.ssh/appuser
   ProxyCommand ssh -W %h:%p bastion
   StrictHostKeyChecking no

# Команда подключения к хосту за bastion через alias:
ssh someinternalhost

bastion_IP = 62.84.117.242
someinternalhost_IP = 10.128.0.35

# cloud-testapp
testapp_IP = 62.84.117.173
testapp_port = 9292

# Команда на создание VM c установленными и запущенными приложениями в обладе yandex.cloud
yc compute instance create \
  --name reddit-app-autosetup \
  --hostname reddit-app-autosetup \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --metadata-from-file user-data=./metadata.yaml
# Сборка образов VM при помощи packer
# создание сервисного аккаунта для packer в yandex.cloud (account yc-service)
# делегирование прав сервисному аккаунту для packer (editor - role)
# создание service account key file (key.json)
# создание файла шаблона packer (ubuntu16.json)
# cоздание скриптов для provisioners
# проверка валидности и сборка образа по шаблону ubuntu16.json
packer validate -var-file variables.json ubuntu16.json
packer build -var-file variables.json ubuntu16.json
# создание VM:
cd config-scripts
./create-reddit-vm.sh
