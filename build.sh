
#source /opt/xilinx_linux_gnu/environment-setup-zynq-arch-linux-gnu

export LD_LIBRARY_PATH=/ipsec/lib
export PKG_CONFIG_PATH=/ipsec/lib/pkgconfig/
export PKG_CONFIG_LIBDIR=/ipsec/lib/pkgconfig/

./configure   --prefix=/ipsec --host=arm-linux \
		LDFLAGS="-L/ipsec/lib" \
		CFLAGS="-I/ipsec/include" \
		--enable-kernel-libipsec  \
		--disable-gmp --disable-openssl  \
		--enable-gmalg --with-gmalg_interior=yes
make
make install
