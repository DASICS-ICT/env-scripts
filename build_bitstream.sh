#!/bin/zsh
set -e
cp -r $NOOP_HOME/build/rtl ./core-rtl
python3 ./fpga/postprocess-nh3-dir.py ./core-rtl
make -C ./xs_nanhu_fpga update_core_flist CORE_DIR=$PWD/core-rtl
make -C ./xs_nanhu_fpga nanhu_v3 CORE_DIR=$PWD/core-rtl
make -C ./xs_nanhu_fpga bitstream CORE_DIR=$PWD/core-rtl
