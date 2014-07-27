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

BUILD_DIR=${0%/*}
cd $BUILD_DIR
MINICONDA_SETUP=Miniconda3-3.5.5-Windows-$1.exe
echo $'\n'Downloading $MINICONDA_SETUP
curl -# -L http://repo.continuum.io/miniconda/$MINICONDA_SETUP -O
INSTALL_DIR=~
./$MINICONDA_SETUP

ULAFF_DIR=$INSTALL_DIR/ULAFF
mkdir $ULAFF_DIR
echo; git -C $ULAFF_DIR clone https://github.com/ULAFF/notebooks.git -b notebooks
echo; git -C $ULAFF_DIR clone https://github.com/ULAFF/lib.git
echo; git -C $ULAFF_DIR clone https://github.com/ULAFF/tools.git

SOFTWARE_DIR=$ULAFF_DIR/software
mv $INSTALL_DIR/Miniconda3 $SOFTWARE_DIR
echo $'\n'Installing Python Packages
cd $SOFTWARE_DIR/Scripts
cmd "/C conda.exe update conda --y"
cmd "/C conda.exe install setuptools numpy sympy matplotlib --y"
cmd "/C easy_install.exe -U pyparsing"
cmd "/C conda.exe install ipython-notebook --y"
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
cp LAFF.bat $ULAFF_DIR

echo $'\n'Cleaning up...
rm -rf $SOFTWARE_DIR/pkgs
rm $MINICONDA_SETUP
rm v$MATHJAX_VERSION.tar.gz

echo $'\n'All Done!
