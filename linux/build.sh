#!/bin/bash
ARCH="x86"
PKGNAME="linux32LAFFpkg"
cd "$(dirname "$(readlink -f "${0}")")"
bash Miniconda3-2.2.2-Linux-$ARCH.sh
mv ~/anaconda ~/LAFF
cd ~/LAFF/bin
./python ./conda update conda --y
./python ./conda install setuptools numpy sympy matplotlib --y
./python ./easy_install -U pyparsing
./python ./conda install ipython-notebook --y 
rm -rf ../pkgs
apt-get install -y python-software-properties
add-apt-repository -y ppa:git-core/ppa
apt-get update
apt-get install -y git
cd -
STATIC="$HOME/LAFF/.ipython/profile_default/static"
mkdir -p $STATIC
mkdir ~/LAFF/notebooks
tar -jxf ../shared/mathjax.tar.bz2 -C $STATIC
cp -r ../shared/custom $STATIC
cd ~/LAFF/notebooks
git init
cd -
cp ../shared/config ~/LAFF/notebooks/.git
cp LAFF ~/LAFF/
tar -jcf $PKGNAME`date +\(%b-%d-%Y\)`.tar.bz2 -C ~/ LAFF
echo "Finished building linux LAFF package."
read
