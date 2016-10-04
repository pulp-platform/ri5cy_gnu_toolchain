BUILD_DIR ?= $(CURDIR)/build
PKG_DIR ?= $(CURDIR)/install
TOOL_PATCH_DIR ?= $(CURDIR)/toolchain-patches

.PHONY: build

PATCH_FILES = gcc.c gcse.c target.def builtins.c omp-low.c ira-color.c doc/tm.texi doc/tm.texi.in config/riscv/pulp_builtins.def

build:
	if [ ! -e toolchain ]; then git clone https://github.com/riscv/riscv-gnu-toolchain.git toolchain; fi
	cd toolchain && git checkout d038d596dc1d8e47ace22ab742cd40c2f22d659e
	if [ -d $(TOOL_PATCH_DIR) ]; then \
		cd toolchain; \
		FILES=$$(ls $(TOOL_PATCH_DIR)/*.patch | sort); \
		for tmp in $$FILES; do \
			test=$$(patch -p1 -R -N --dry-run <$$tmp 1>/dev/null 2>&1; echo $$?);  \
			if [ "$$test" != "0" ]; then patch -p1 -N <$$tmp; fi \
		done; \
	fi

	mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && $(CURDIR)/toolchain/configure --with-xlen=32 --with-arch=IM --disable-atomic --disable-float --disable-multilib --prefix=$(PKG_DIR)
	cd $(BUILD_DIR) && make && make install

	cd $(BUILD_DIR) && tar mxvfz $(CURDIR)/riscv_tools_delta.tar.gz
	cd toolchain && tar mxvfz $(CURDIR)/riscv_tools_delta.tar.gz

	for file in $(PATCH_FILES); do cd $(BUILD_DIR)/src/gcc/gcc && rm -f $$file && ln ../../../gcc/gcc/$$file $$file; done
	for file in $(PATCH_FILES); do cd $(BUILD_DIR)/src/newlib-gcc/gcc && rm -f $$file && ln ../../../gcc/gcc/$$file $$file; done
	cd $(BUILD_DIR)/src/newlib-gcc/gcc/config/riscv && rm -f pulp.md && ln ../../../../../gcc/gcc/config/riscv/pulp.md pulp.md
	cd $(BUILD_DIR)/src/gcc/gcc/config/riscv && rm -f riscv-opts.h && ln ../../../../../gcc/gcc/config/riscv/riscv-opts.h riscv-opts.h
	cd $(BUILD_DIR)/src/newlib-gcc/gcc/config/riscv && rm -f riscv-opts.h && ln ../../../../../gcc/gcc/config/riscv/riscv-opts.h riscv-opts.h

	cd $(BUILD_DIR)/build-binutils-newlib && make clean && make && make install
	cd $(BUILD_DIR)/build-gcc-newlib/ && make clean && make && make install

	#cd build/build-gcc-newlib && cat Makefile | sed s/'CXXFLAGS_FOR_TARGET = -g -O2'/'CXXFLAGS_FOR_TARGET = -g -O2 -march=IXpulpv2'/g | sed s/'CFLAGS_FOR_TARGET = -g -O2'/'CFLAGS_FOR_TARGET = -g -O2 -march=IXpulpv2'/g > Makefile.new && mv Makefile.new Makefile && make clean all install
