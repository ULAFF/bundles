#!/bin/bash
LAFFDIR="$(dirname "$(readlink -f "${0}")")"
cd $LAFFDIR/notebooks
vagrant up
vagrant plugin install vagrant-vbguest
vagrant reload
vagrant plugin uninstall vagrant-vbguest
vagrant reload
vagrant ssh
vagrant provision
vagrant reload
vagrant halt
vagrant package --output vmLAFFpkg/laff.box
zip -r vmLAFFpkg`date +\(%b-%d-%Y\)`.zip vmLAFFpkg -x ".DS_Store"
echo "Done setting up LAFF VM."
