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

bastion_IP=62.84.117.242 someinternalhost_IP=10.128.0.35
