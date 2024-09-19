#!/bin/sh

set -e # 在遇到非零返回值时立即退出

start=$(date +%s)

echo " 编译txt2man 和 atlas:" 
git clone https://github.com/mvertes/txt2man.git
cd txt2man
git checkout tags/txt2man-1.7.1
make install prefix=/home/$(whoami)/txt2man-install
PATH=/home/$(whoami)/txt2man-install/bin:$PATH
echo "# txt2man" >> ~/.bashrc
echo "export PATH=$PATH" >> ~/.bashrc
source ~/.bashrc

cd ~

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
PATH=/home/$(whoami)/ATLAS/bin:$PATH
echo "# atlas" >> ~/.bashrc
echo "export PATH=$PATH" >> ~/.bashrc
source ~/.bashrc

echo " 编译caffe:"
git clone https://github.com/BVLC/caffe.git
cd caffe
patch -p1 < ~/caffe-patch.patch

export LDFLAGS="-L/usr/lib -Wl,-rpath=/usr/lib"
make all -j $(nproc)
make test -j $(nproc)
make runtest -j $(nproc)

CAFFE=$(pwd)
PATH="$CAFFE/build/tools:$PATH"

echo "向 ~/.bashrc 文件中添加环境变量"
echo "# caffe" >> ~/.bashrc
echo "export CAFFE=$CAFFE" >> ~/.bashrc
echo "export PATH=$PATH" >> ~/.bashrc
source ~/.bashrc
caffe --version || { echo "Caffe 构建失败"; exit 1; }

end=$(date +%s)
runtime=$((end-start))
echo "脚本执行时长： $runtime s"
