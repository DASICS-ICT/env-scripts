all: rtl project bitstream

rtl:
	mkdir -p core-rtl
	cp -r $(NOOP_HOME)/build/*.sv ./core-rtl #for nh3
#	cp -r $(NOOP_HOME)/build/rtl/*.sv ./core-rtl #for nh3-ext
	python3 ./fpga/postprocess-nh3-dir.py ./core-rtl

project: 
	make -C ./xs_nanhu_fpga update_core_flist CORE_DIR=$(PWD)/core-rtl
	make -C ./xs_nanhu_fpga nanhu_v3 CORE_DIR=$(PWD)/core-rtl

bitstream: 
	vivado -mode batch -source $(PWD)/fpga/v3a_ext_flow.tcl > bitstream_log.txt 2>&1 & 
#	make -C ./xs_nanhu_fpga bitstream CORE_DIR=$(PWD)/core-rtl

clean:
	rm -rf ./core-rtl
	rm -rf ./xs_nanhu_fpga/xs_nanhu
	
.PHONY: rtl project bitstream clean
