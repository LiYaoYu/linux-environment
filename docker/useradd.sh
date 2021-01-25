#!/usr/bin/env bash

useradd -d /home/yaoyu -m $1
passwd $1

echo 'yaoyu ALL=(ALL) ALL' >> /etc/sudoers
