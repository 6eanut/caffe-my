git clone https://github.com/mvertes/txt2man.git
cd txt2man
git checkout tags/txt2man-1.7.1
make install prefix=/home/$(whoami)/txt2man-install
export PATH=/home/$(whoami)/txt2man-install/bin:$PATH

git clone https://github.com/math-atlas/math-atlas.git
cd math-atlas
git checkout tags/v3.11.40
make
cd TEST
make
./atltar.sh
mv atlas3.11.40.tar.bz2 ~
cd ~
tar -xvf atlas3.11.40.tar.bz2
export PATH=/home/$(whoami)/ATLAS/bin:$PATH

#makefile.config 改成atlas