#!/bin/sh

VAGRANT_HOME=/opt/vagrant/embedded/gems/gems/vagrant-1.6.5

echo "# VAGRANT_HOME=${VAGRANT_HOME}"

cd "${VAGRANT_HOME}"
find . -name "*.ORIG" | while read oldf; do
    f=$(echo "$oldf" | sed -e 's/.ORIG//')
    echo "\n#\n# Patches against $f\n#"
    echo 
    diff -u $oldf $f
done

# EOF
