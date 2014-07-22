#!/bin/bash
INSTALL_DIR=${0%/*}
cd $INSTALL_DIR
MINICONDA_SETUP=Miniconda3-3.5.5-MacOSX-x86_64.sh
echo $'\n'Downloading $MINICONDA_SETUP
curl -# -L http://repo.continuum.io/miniconda/$MINICONDA_SETUP -O
bash $MINICONDA_SETUP

ULAFF_DIR=$INSTALL_DIR/ULAFF
mkdir $ULAFF_DIR
echo; git -C $ULAFF_DIR clone https://github.com/ULAFF/notebooks.git -b notebooks
echo; git -C $ULAFF_DIR clone https://github.com/ULAFF/lib.git
echo; git -C $ULAFF_DIR clone https://github.com/ULAFF/tools.git

SOFTWARE_DIR=$ULAFF_DIR/software
mv ~/miniconda3 $SOFTWARE_DIR
echo $'\n'Installing Python Packages
$SOFTWARE_DIR/bin/python $SOFTWARE_DIR/bin/conda update conda --y
$SOFTWARE_DIR/bin/python $SOFTWARE_DIR/bin/conda install setuptools numpy sympy matplotlib --y
$SOFTWARE_DIR/bin/python $SOFTWARE_DIR/bin/easy_install -U pyparsing
$SOFTWARE_DIR/bin/python $SOFTWARE_DIR/bin/conda install ipython-notebook --y

STATIC_DIR=$SOFTWARE_DIR/.ipython/profile_default/static
mkdir -p $STATIC_DIR
MATHJAX_VERSION=2.4-latest
echo $'\n'Downloading MathJax-$MATHJAX_VERSION
curl -# -L https://github.com/mathjax/MathJax/archive/v$MATHJAX_VERSION.tar.gz -O
echo Decompressing MathJax...
tar -jxf v$MATHJAX_VERSION.tar.gz -C $STATIC_DIR
mv $STATIC_DIR/MathJax-$MATHJAX_VERSION $STATIC_DIR/mathjax
cp -r ../shared/custom $STATIC_DIR
cp LAFF $ULAFF_DIR

echo $'\n'Cleaning up...
rm -rf $SOFTWARE_DIR/pkgs
rm $MINICONDA_SETUP
rm v$MATHJAX_VERSION.tar.gz

echo $'\n'Compressing ULAFF package...
tar -jcf macULAFFpkg`date +\(%b-%d-%Y\)`.tar.bz2 -C $INSTALL_DIR ULAFF

echo $'\n'All Done!
