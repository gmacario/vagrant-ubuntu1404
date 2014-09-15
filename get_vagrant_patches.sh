#!/bin/sh

# Poor-man version control system
# This shell script prints a diff of all files which have
# a corresponding "*.ORIG" in the same directory
# This may be useful when applying workarounds to installed programs

#VAGRANT_HOME=/opt/vagrant/embedded/gems/gems/vagrant-1.6.5
#VAGRANT_HOME=/Applications/Vagrant/embedded/gems/gems/vagrant-1.6.3
VAGRANT_HOME=/cygdrive/c/HashiCorp/Vagrant/embedded/gems/gems/vagrant-1.6.5

if [ -z "${VAGRANT_HOME}" -o ! -d "${VAGRANT_HOME}" ]; then
    echo "ERROR: Please check VAGRANT_HOME: ${VAGRANT_HOME}"
    exit 1
fi

echo "# VAGRANT_HOME=${VAGRANT_HOME}"

cd "${VAGRANT_HOME}"
find . -name "*.ORIG" | while read oldf; do
    f=$(echo "$oldf" | sed -e 's/.ORIG//')
    echo "\n#\n# Patches against $f\n#"
    echo 
    diff -u $oldf $f
done

# EOF
