all: rtl project bitstream

rtl:
	cp -r $(NOOP_HOME)/build/rtl $(PWD)/core-rtl
	python3 ./fpga/postprocess-nh3-dir.py $(PWD)/core-rtl

project: core-rtl
	make -C ./xs_nanhu_fpga update_core_flist CORE_DIR=$(PWD)/core-rtl
	make -C ./xs_nanhu_fpga nanhu_v3 CORE_DIR=$(PWD)/core-rtl

bitstream: core-rtl project
	vivado -mode batch -source $(PWD)/fpga/v3a-ext-flow.tcl 2>&1 bitstream_log.txt & 
#	make -C ./xs_nanhu_fpga bitstream CORE_DIR=$(PWD)/core-rtl

clean:
	rm -rf $(PWD)/core-rtl
	rm -rf $(PWD)/xs_nanhu_fpga/xs_nanhu
	
.PHONY: rtl project bitstream clean
