#!/bin/sh

yc compute instance create \
--name reddit-app \
--hostname reddit-app \
--memory=2 \
--create-boot-disk image-family=reddit-full,size=10GB \
--network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
--metadata serial-port-enable=1 \
--zone=ru-central1-a \
--metadata-from-file user-data=metadata-packer.yaml
