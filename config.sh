version=6.99
file=xfoil$version.tgz
source=http://web.mit.edu/drela/Public/web/xfoil/$file
downloaded_file=$version.tar.gz

wget -O $downloaded_file $source

mkdir $version && tar -xvzf $downloaded_file --strip-components=1 -C $version/

rm -rf $downloaded_file

cd $version

patch -Np1 -i ../xfoil-fix-write-after-end.patch

patch -Np1 -i ../xfoil-overflow.patch

patch -Np1 -i ../xfoil-osmap.patch

patch -Np1 -i ../xfoil-build.patch

cd orrs/bin

make -f Makefile_DP FTNLIB="${LDFLAGS}" OS

cd ../../plotlib

make CFLAGS="${CFLAGS} -DUNDERSCORE"

cd ../bin

make -f Makefile_gfortran CFLAGS="${CFLAGS} -DUNDERSCORE" FTNLIB="${LDFLAGS}"

cd ../..

## Install location
install_location=bins

install -m755 -d $install_location

install -m755 $version/bin/{xfoil,pplot,pxplot} $install_location

rm -rf $version
