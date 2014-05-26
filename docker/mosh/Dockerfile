FROM ubuntu

yum install git-core boost-devel libutempter-devel ncurses-devel zlib-devel perl-CPAN cpp make automake gcc-c++
    echo "say yes twice"
    cpan IO::Pty
    curl -O "http://protobuf.googlecode.com/files/protobuf-2.4.1.tar.gz"
    tar -xzf protobuf-2.4.1.tar.gz
    pushd protobuf-2.4.1
    ./configure
    make && make install
    echo "/usr/local/lib" >> /etc/ld.so.conf.d/usr_local_lib.conf
    popd
    git clone https://github.com/keithw/mosh
    cd mosh
    ./autogen.sh
    ./configure PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
    make && make install
