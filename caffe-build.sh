#!/bin/sh

set -e # 在遇到非零返回值时立即退出

start=$(date +%s)

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
