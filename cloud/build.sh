#!/bin/bash
cd "$(dirname "$(readlink -f "${0}")")"
bash Miniconda3-3.0.0-Linux-x86_64.sh
mv ~/miniconda3 ~/LAFF
cd ~/LAFF/bin
./python ./conda update conda --y 
./python ./conda install setuptools numpy sympy matplotlib --y 
./python ./easy_install -U pyparsing
./python ./conda install ipython-notebook --y 
rm -rf ../pkgs
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
cp start ~/LAFF/
zip -r cloudLAFFpkg`date +\(%b-%d-%Y\)`.zip ~/LAFF > /dev/null
