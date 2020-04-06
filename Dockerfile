FROM debian:latest

RUN mkdir /home/gcc_cross

WORKDIR /home/gcc_cross

RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y bison
RUN apt-get install -y flex
RUN apt-get install -y libgmp3-dev
RUN apt-get install -y libmpc-dev
RUN apt-get install -y libmpfr-dev
RUN apt-get install -y texinfo
RUN apt-get install -y libcloog-isl-dev
RUN apt-get install -y libisl-dev

RUN export PREFIX="$HOME/opt/cross"
RUN export TARGET=i686-elf
RUN export PATH="$PREFIX/bin:$PATH"

RUN cd $HOME/src
RUN mkdir build-binutils
RUN cd build-binutils
RUN ../binutils-x.y.z/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
RUN make
RUN make install

RUN cd $HOME/src
RUN which -- $TARGET-as || echo $TARGET-as is not in the PATH
RUN mkdir build-gcc
RUN cd build-gcc
RUN ../gcc-x.y.z/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
RUN make all-gcc
RUN make all-target-libgcc
RUN make install-gcc
RUN make install-target-libgcc

RUN echo $HOME/opt/cross/bin/$TARGET-gcc --version >> .bashrc
RUN export PATH="$HOME/opt/cross/bin:$PATH"
