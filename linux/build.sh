#!/bin/bash
if ! [[ (( $1 == x86 || $1 == x86_64 )) ]]
then
  echo $'\n'Input validation failed!
  echo "    Usage: ./build.sh [arch]"
  echo "    Please specify desired architecture by passing the correct argument:"
  echo "      * [arch] should be either x86 for 32-bit or x86_64 for 64-bit."
  echo $'\n'"Press the Enter key to continue..."
  read
  exit 1
fi

BUILD_DIR="$(dirname "$(readlink -f "${0}")")"
cd $BUILD_DIR
MINICONDA_SETUP=Miniconda3-3.5.5-Linux-$1.sh
echo $'\n'Downloading $MINICONDA_SETUP
curl -# -L http://repo.continuum.io/miniconda/$MINICONDA_SETUP -O
INSTALL_DIR=~
bash $MINICONDA_SETUP

ULAFF_DIR=$INSTALL_DIR/ULAFF
mkdir $ULAFF_DIR
echo; git clone https://github.com/ULAFF/notebooks.git -b notebooks $ULAFF_DIR/notebooks
echo; git clone https://github.com/ULAFF/lib.git $ULAFF_DIR/lib
echo; git clone https://github.com/ULAFF/tools.git $ULAFF_DIR/tools

SOFTWARE_DIR=$ULAFF_DIR/software
mv $INSTALL_DIR/miniconda3 $SOFTWARE_DIR
echo $'\n'Installing Python Packages
cd $SOFTWARE_DIR/bin
./python ./conda update conda --y
./python ./conda install setuptools numpy sympy matplotlib --y
./python ./easy_install -U pyparsing
./python ./conda install ipython-notebook --y
cd -

STATIC_DIR=$SOFTWARE_DIR/.ipython/profile_default/static
mkdir -p $STATIC_DIR
MATHJAX_VERSION=2.4-latest
echo $'\n'Downloading MathJax-$MATHJAX_VERSION
curl -# -L https://github.com/mathjax/MathJax/archive/v$MATHJAX_VERSION.tar.gz -O
echo Decompressing MathJax...
tar -zxf v$MATHJAX_VERSION.tar.gz -C $STATIC_DIR
mv $STATIC_DIR/MathJax-$MATHJAX_VERSION $STATIC_DIR/mathjax
cp -r ../shared/custom $STATIC_DIR
cp LAFF $ULAFF_DIR

echo $'\n'Cleaning up...
rm -rf $SOFTWARE_DIR/pkgs
rm $MINICONDA_SETUP
rm v$MATHJAX_VERSION.tar.gz

echo $'\n'Compressing ULAFF package...
tar -jcf linuxULAFFpkg$1`date +\(%b-%d-%Y\)`.tar.bz2 -C $INSTALL_DIR ULAFF

echo $'\n'All Done!
