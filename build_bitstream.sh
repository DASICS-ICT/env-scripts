#!/bin/zsh
set -e
cp -r $NOOP_HOME/build/rtl .
python3 ./fpga/postprocess-nh3.py ./rtl
make -C ./xs_nanhu_fpga update_core_flist CORE_DIR=$PWD/rtl
make -C ./xs_nanhu_fpga nanhu_v3 CORE_DIR=$PWD/rtl
make -C ./xs_nanhu_fpga bitstream CORE_DIR=$PWD/rtl
