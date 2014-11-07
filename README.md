vagrant-ubuntu1404
==================
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/gmacario/vagrant-ubuntu1404?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Project for deploying Ubuntu-desktop 14.04 using Vagrant.

You may configure the actual packages to be installed through:
* `Vagrantfile`
* The `bootstrap.sh` script.

### Checking out project from git

```
git clone git@github.com:gmacario/vagrant-ubuntu1404.git
cd vagrant-ubuntu1404
```

### Testing using the VirtualBox (default) provider
Build and start the guest VM:
```
vagrant up --provider=virtualbox
```

When the guest OS is up and running you may login via SSH:
```
vagrant ssh
```

### Testing using the Docker provider

Download the private SSH key to login to the phusion baseimage-docker:
```
curl \
https://raw.githubusercontent.com/phusion/baseimage-docker/master/image/insecure_key \
>phusion.key
```

Now build and start the guest VM as usual specifying `--provider=docker`

```
vagrant up --provider=docker
```

When the guest OS is up and running you may login via SSH:
```
vagrant ssh
```

EOF
