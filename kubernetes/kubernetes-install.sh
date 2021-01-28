#!/usr/bin/env bash

apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet=1.16.15-00 kubeadm=1.16.15-00 kubectl=1.16.15-00
apt-mark hold kubelet kubeadm kubectl
