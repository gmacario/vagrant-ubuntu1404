vagrant-ubuntu1404
==================

[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/gmacario/vagrant-ubuntu1404?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![PullReview stats](https://www.pullreview.com/github/gmacario/vagrant-ubuntu1404/badges/master.svg?)](https://www.pullreview.com/github/gmacario/vagrant-ubuntu1404/reviews/master)
[![Stories in Ready](https://badge.waffle.io/gmacario/vagrant-ubuntu1404.png?label=ready&title=Ready)](https://waffle.io/gmacario/vagrant-ubuntu1404)

Project for deploying [Ubuntu](http://www.ubuntu.com/) 14.04 using [Vagrant](https://www.vagrantup.com/).

You may configure the actual packages to be installed through:
* `Vagrantfile`
* The `bootstrap.sh` script.

### Checking out project from git

```
$ git clone https://github.com/gmacario/vagrant-ubuntu1404.git
$ cd vagrant-ubuntu1404
```

### Testing using the VirtualBox (default) provider
Build and start the guest VM:

```
$ vagrant up --provider=virtualbox
```

When the guest OS is up and running you may login via SSH:

```
$ vagrant ssh
```

### Testing using the Docker provider

Download the private SSH key to login to the container:

```
$ curl -o phusion.key \
https://raw.githubusercontent.com/phusion/baseimage-docker/master/image/services/sshd/keys/insecure_key
```

Now build and start the guest VM as usual specifying `--provider=docker`

```
$ vagrant up --provider=docker
```

When the guest OS is up and running you may login via SSH:

```
$ vagrant ssh
```

<!-- EOF -->
