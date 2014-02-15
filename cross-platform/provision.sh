#!/usr/bin/env bash
apt-get update
apt-get install -y build-essential libtool autoconf automake
apt-get install -y python-software-properties
add-apt-repository -y ppa:fkrull/deadsnakes
add-apt-repository -y ppa:git-core/ppa
apt-get update
apt-get install -y python3.3
apt-get install -y python3.3-dev
apt-get install -y curl
curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py | python3.3
rm setuptools-2.1.tar.gz
curl https://raw.github.com/pypa/pip/master/contrib/get-pip.py | python3.3
curl -O http://download.zeromq.org/zeromq-3.2.4.tar.gz
tar zxvf zeromq-3.2.4.tar.gz && cd zeromq-3.2.4
./configure
make && make install
cd .. && rm -rf zeromq-3.2.4 zeromq-3.2.4.tar.gz
easy_install ipython[notebook]
easy_install numpy
easy_install https://github.com/sympy/sympy/releases/download/sympy-0.7.4.1/sympy-0.7.4.1.tar.gz 
apt-get install -y libfreetype6-dev
apt-get install -y libpng12-dev
easy_install matplotlib
apt-get install -y git
apt-get -y autoremove
apt-get -y clean
STATIC="/home/vagrant/.ipython/profile_default/static"
mkdir -p $STATIC
chown -R vagrant:vagrant /home/vagrant/.ipython
cd /vagrant
mkdir vmLAFFpkg/notebooks
tar -jxf shared/mathjax.tar.bz2 -C $STATIC
cp -r shared/custom $STATIC
cd vmLAFFpkg/notebooks
git init
cd -
cp shared/config vmLAFFpkg/notebooks/.git
cp LAFF /home/vagrant
echo "Done Provisioning LAFF VM."
