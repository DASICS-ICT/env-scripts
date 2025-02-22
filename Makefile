all: rtl project bitstream

rtl:
	cp -r $(NOOP_HOME)/build/rtl ./core-rtl
	python3 ./fpga/postprocess-nh3-dir.py ./core-rtl

project: core-rtl
	make -C ./xs_nanhu_fpga update_core_flist CORE_DIR=$(PWD)/core-rtl
	make -C ./xs_nanhu_fpga nanhu_v3 CORE_DIR=$(PWD)/core-rtl

bitstream: core-rtl project
	make -C ./xs_nanhu_fpga bitstream CORE_DIR=$(PWD)/core-rtl

clean:
	rm -rf ./core-rtl
	rm -rf ./xs_nanhu_fpga/xs_nanhu

.PHONY: rtl project bitstream clean