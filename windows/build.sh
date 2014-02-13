./Miniconda3-2.2.8-Windows-x86.exe
mv ~/anaconda ~/LAFF
cd ~/LAFF/Scripts
cmd "/C conda.bat update conda --y"
cmd "/C conda.bat install setuptools numpy sympy matplotlib --y"
cmd "/C easy_install.bat -U pyparsing"
cmd "/C conda.bat install ipython-notebook --y"
rm -rf ../pkgs
cd -
STATIC="$HOME/LAFF/.ipython/profile_default/static"
mkdir -p $STATIC
mkdir ~/LAFF/notebooks
tar -jxf ../shared/mathjax.tar.bz2 -C $STATIC
cp -r ../shared/custom $STATIC
tar -jxf PortableGit.tar.bz2 -C ~/LAFF
cd ~/LAFF/notebooks
../PortableGit/cmd/git init
cd -
cp ../shared/config ~/LAFF/notebooks/.git
cp LAFF.bat ~/LAFF
echo "Finished building windows LAFF package."
read
