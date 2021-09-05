#!/bin/bash
# https://blog.csdn.net/qq_41054313

yum -y update

yum -y install wget

wget https://218.13.24.187:8880/jdk-16.0.2_linux-x64_bin.rpm

yum -y install jdk-16.0.2_linux-x64_bin.rpm

echo "install success"