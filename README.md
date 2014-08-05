vagrant-ubuntu1404
==================

Vagrant project for deploying Ubuntu-desktop 14.04.

### Testing

```
git clone git@github.com:gmacario/vagrant-ubuntu1404.git
cd vagrant-ubuntu1404
git checkout docker-provider

curl https://raw.githubusercontent.com/phusion/baseimage-docker/master/image/insecure_key >phusion.key

vagrant up --provider=docker
vagrant ssh
```

EOF
