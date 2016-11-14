# How to make binary tarballs

If you wanna make tarballs for buildpacks, you do following steps step by step. good luck.

## Requirement
* Dyno : Cedar-14
* Libraries : [here](#RequirementLibraries)

## AWS CLI (Tools)
``` sh
    pip install awscli
    aws configure
    > AWS Access Key ID [None]:     # type your AWSAccessKeyId
    > AWS Secret Access Key [None]: # type your AWSSecretKey
    > Default region name [None]:   # type your s3 region
    > Default output format [None]: # hit enter
```

## Mecab & IPA Dictionary
``` sh
    # build mecab
    cd /app/tmp
    wget "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE" -O mecab-0.996.tar.gz
    tar zxf mecab-0.996.tar.gz
    cd /app/tmp/mecab-0.996
    ./configure --silent --prefix=/app/.vendor/mecab-0.996 --sysconfdir=/app/.vendor/mecab-0.996/etc
    make --silent
    make --silent install

    # build ipadic
    cd /app/tmp
    wget "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM" -O mecab-ipadic-2.7.0-20070801.tar.gz
    tar zxf mecab-ipadic-2.7.0-20070801.tar.gz
    cd /app/tmp/mecab-ipadic-2.7.0-20070801
    ./configure --silent --prefix=/app/.vendor/mecab-ipadic-2.7.0-20070801 --with-charset=utf8 --with-dicdir=/app/.vendor/mecab-ipadic-2.7.0-20070801/lib/mecab/dic/ipadic --with-mecab-config=/app/.vendor/mecab-0.996/bin/mecab-config
    make --silent
    make --silent install

    # change mecab dictionary path
    cd /app/.vendor/mecab-0.996/etc/
    echo "dicdir = /app/.vendor/mecab-ipadic-2.7.0-20070801/lib/mecab/dic/ipadic" > mecabrc

    # make tarballs
    cd /app/.vendor
    tar zcf mecab-0.996.tar.gz mecab-0.996/*
    cp mecab-0.996.tar.gz /app/upload
    tar zcf mecab-ipadic-2.7.0-20070801.tar.gz mecab-ipadic-2.7.0-20070801/*
    cp mecab-ipadic-2.7.0-20070801.tar.gz /app/upload

    # upload to s3
    cd /app
    aws s3 sync upload s3://slugbucket --acl private
```

## Tesseract & Leptonica
``` sh
    # build leptonica
    curl -s -L http://www.leptonica.com/source/leptonica-1.71.tar.gz | tar zx -C /app/tmp
    cd /app/tmp/leptonica-1.71
    ./configure --silent --prefix=/app/.vendor/leptonica-1.71
    make --silent
    make --silent install

    # build tesseract
    cd /app/tmp
    wget https://github.com/tesseract-ocr/tesseract/archive/3.04.01.zip
    unzip 3.04.01.zip
    cd /app/tmp/tesseract-3.04.01
    ./autogen.sh
    LIBLEPT_HEADERSDIR=/app/.vendor/leptonica-1.71/include ./configure --silent --prefix=/app/.vendor/tesseract-3.04.01 --with-extra-libraries=/app/.vendor/leptonica-1.71/lib
    LDFLAGS="-L/usr/local/lib" CFLAGS="-I/usr/local/include" make --silent
    make --silent install

    # make tarballs
    cd /app/.vendor
    tar zcf leptonica-1.71.tar.gz leptonica-1.71/*
    cp leptonica-1.71.tar.gz /app/upload
    tar zcf tesseract-3.04.01.tar.gz tesseract-3.04.01/*
    cp tesseract-3.04.01.tar.gz /app/upload

    # upload to s3
    cd /app
    aws s3 sync upload s3://slugbucket --acl private
```

## OpenCV & CMake
``` sh
    #build cmake
    curl -s -L https://cmake.org/files/v3.6/cmake-3.6.2.tar.gz | tar zx -C /app/tmp
    cd /app/tmp/cmake-3.6.2/
    ./bootstrap --prefix=/app/.vendor/cmake-3.6.2/
    make --silent
    make --silent install

    #build opencv
    cd /app/tmp
    wget https://github.com/Itseez/opencv/archive/3.1.0.zip
    unzip 3.1.0.zip
    cd opencv-3.1.0
    mkdir release
    cd release
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/app/.vendor -D BUILD_opencv_java=OFF -D WITH_IPP=OFF -D WITH_1394=OFF -D WITH_FFMPEG=OFF -D BUILD_EXAMPLES=OFF -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_DOCS=OFF -D BUILD_opencv_python2=ON -D BUILD_opencv_python3=ON -D BUILD_opencv_video=OFF -D BUILD_opencv_videoio=OFF -D BUILD_opencv_videostab=OFF -D PYTHON_EXECUTABLE=$(which python) ..
    make --silent
    make --silent install

    # make tarballs
    cd /app/.vendor
    tar zcf opencv-3.1.0.tar.gz opencv-3.1.0/*
    cp opencv-3.1.0.tar.gz /app/upload

    # upload to s3
    cd /app
    aws s3 sync upload s3://slugbucket --acl private
```

## ImageMagick
``` sh
    # build ImageMagick
    sudo curl -s -L http://www.imagemagick.org/download/releases/ImageMagick-7.0.1-10.tar.xz | sudo tar Jx -C /app/tmp
    ./configure --silent --prefix=/app/.vendor/ImageMagick-7.0.1-10
    make --silent
    make --silent install

    # make tarballs
    cd /app/.vendor
    tar zcf ImageMagick-7.0.1-10.tar.gz ImageMagick-7.0.1-10/*
    cp ImageMagick-7.0.1-10.tar.gz /app/upload

    # upload to s3
    cd /app
    aws s3 sync upload s3://slugbucket --acl private
```

<span id="RequirementLibraries"></span>
## Requirement libraries by Cader-14

Following lists is a result of `ldd` command that dynamic executable files installed by this buildpack.<br />
If following library's version is updated, you have to remake depending tarballs.

### mecab-0.996
* ./mecab:
    * linux-vdso.so.1 =>  (0x00007ffd6d9d5000)
    * ~~libmecab.so.2 => /app/.vendor/mecab-0.996/lib/libmecab.so.2 (0x00007f3ae63cf000)~~
    * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f3ae600a000)
    * libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f3ae5dec000)
    * libstdc++.so.6 => /usr/lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f3ae5ae8000)
    * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f3ae57e2000)
    * /lib64/ld-linux-x86-64.so.2 (0x00007f3ae6798000)
    * libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f3ae55cc000)
* ./mecab-config:
    * not a dynamic executable

### mecab-ipadic-2.7.0-20070801
* not a dynamic executable

### leptonica-1.71
* ./convertfilestopdf:
    * linux-vdso.so.1 =>  (0x00007ffe91b83000)
    * ~~liblept.so.4 => /app/.vendor/leptonica-1.71/lib/liblept.so.4 (0x00007f91a0535000)~~
    * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f91a0170000)
    * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f919fe6a000)
    * libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f919fc51000)
    * libpng12.so.0 => /lib/x86_64-linux-gnu/libpng12.so.0 (0x00007f919fa2b000)
    * libjpeg.so.8 => /usr/lib/x86_64-linux-gnu/libjpeg.so.8 (0x00007f919f7d6000)
    * libtiff.so.5 => /usr/lib/x86_64-linux-gnu/libtiff.so.5 (0x00007f919f564000)
    * /lib64/ld-linux-x86-64.so.2 (0x00007f91a0952000)
    * liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007f919f342000)
    * libjbig.so.0 => /usr/lib/x86_64-linux-gnu/libjbig.so.0 (0x00007f919f134000)
    * libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f919ef30000)
* ./convertfilestops:
    * linux-vdso.so.1 =>  (0x00007ffc29182000)
    * ~~liblept.so.4 => /app/.vendor/leptonica-1.71/lib/liblept.so.4 (0x00007f44d8056000)~~
    * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f44d7c91000)
    * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f44d798b000)
    * libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f44d7772000)
    * libpng12.so.0 => /lib/x86_64-linux-gnu/libpng12.so.0 (0x00007f44d754c000)
    * libjpeg.so.8 => /usr/lib/x86_64-linux-gnu/libjpeg.so.8 (0x00007f44d72f7000)
    * libtiff.so.5 => /usr/lib/x86_64-linux-gnu/libtiff.so.5 (0x00007f44d7085000)
    * /lib64/ld-linux-x86-64.so.2 (0x00007f44d8473000)
    * liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007f44d6e63000)
    * libjbig.so.0 => /usr/lib/x86_64-linux-gnu/libjbig.so.0 (0x00007f44d6c55000)
    * libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f44d6a51000)
* ./convertformat:
    * linux-vdso.so.1 =>  (0x00007fffc6b6a000)
    * ~~liblept.so.4 => /app/.vendor/leptonica-1.71/lib/liblept.so.4 (0x00007f4347b43000)~~
    * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f434777e000)
    * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f4347478000)
    * libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f434725f000)
    * libpng12.so.0 => /lib/x86_64-linux-gnu/libpng12.so.0 (0x00007f4347039000)
    * libjpeg.so.8 => /usr/lib/x86_64-linux-gnu/libjpeg.so.8 (0x00007f4346de4000)
    * libtiff.so.5 => /usr/lib/x86_64-linux-gnu/libtiff.so.5 (0x00007f4346b72000)
    * /lib64/ld-linux-x86-64.so.2 (0x00007f4347f60000)
    * liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007f4346950000)
    * libjbig.so.0 => /usr/lib/x86_64-linux-gnu/libjbig.so.0 (0x00007f4346742000)
    * libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f434653e000)
* ./convertsegfilestopdf:
    * linux-vdso.so.1 =>  (0x00007ffc6f5b3000)
    * ~~liblept.so.4 => /app/.vendor/leptonica-1.71/lib/liblept.so.4 (0x00007fdad62ec000)~~
    * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fdad5f27000)
    * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007fdad5c21000)
    * libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007fdad5a08000)
    * libpng12.so.0 => /lib/x86_64-linux-gnu/libpng12.so.0 (0x00007fdad57e2000)
    * libjpeg.so.8 => /usr/lib/x86_64-linux-gnu/libjpeg.so.8 (0x00007fdad558d000)
    * libtiff.so.5 => /usr/lib/x86_64-linux-gnu/libtiff.so.5 (0x00007fdad531b000)
    * /lib64/ld-linux-x86-64.so.2 (0x00007fdad6709000)
    * liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007fdad50f9000)
    * libjbig.so.0 => /usr/lib/x86_64-linux-gnu/libjbig.so.0 (0x00007fdad4eeb000)
    * libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007fdad4ce7000)
* ./convertsegfilestops:
    * linux-vdso.so.1 =>  (0x00007ffe3fb93000)
    * ~~liblept.so.4 => /app/.vendor/leptonica-1.71/lib/liblept.so.4 (0x00007f904533a000)~~
    * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f9044f75000)
    * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f9044c6f000)
    * libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f9044a56000)
    * libpng12.so.0 => /lib/x86_64-linux-gnu/libpng12.so.0 (0x00007f9044830000)
    * libjpeg.so.8 => /usr/lib/x86_64-linux-gnu/libjpeg.so.8 (0x00007f90445db000)
    * libtiff.so.5 => /usr/lib/x86_64-linux-gnu/libtiff.so.5 (0x00007f9044369000)
    * /lib64/ld-linux-x86-64.so.2 (0x00007f9045757000)
    * liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007f9044147000)
    * libjbig.so.0 => /usr/lib/x86_64-linux-gnu/libjbig.so.0 (0x00007f9043f39000)
    * libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f9043d35000)
* ./converttopdf:
    * linux-vdso.so.1 =>  (0x00007ffe229cf000)
    * ~~liblept.so.4 => /app/.vendor/leptonica-1.71/lib/liblept.so.4 (0x00007fee060e3000)~~
    * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fee05d1e000)
    * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007fee05a18000)
    * libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007fee057ff000)
    * libpng12.so.0 => /lib/x86_64-linux-gnu/libpng12.so.0 (0x00007fee055d9000)
    * libjpeg.so.8 => /usr/lib/x86_64-linux-gnu/libjpeg.so.8 (0x00007fee05384000)
    * libtiff.so.5 => /usr/lib/x86_64-linux-gnu/libtiff.so.5 (0x00007fee05112000)
    * /lib64/ld-linux-x86-64.so.2 (0x00007fee06500000)
    * liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007fee04ef0000)
    * libjbig.so.0 => /usr/lib/x86_64-linux-gnu/libjbig.so.0 (0x00007fee04ce2000)
    * libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007fee04ade000)
* ./converttops:
    * linux-vdso.so.1 =>  (0x00007ffe451fc000)
    * ~~liblept.so.4 => /app/.vendor/leptonica-1.71/lib/liblept.so.4 (0x00007f9880dc1000)~~
    * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f98809fc000)
    * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f98806f6000)
    * libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f98804dd000)
    * libpng12.so.0 => /lib/x86_64-linux-gnu/libpng12.so.0 (0x00007f98802b7000)
    * libjpeg.so.8 => /usr/lib/x86_64-linux-gnu/libjpeg.so.8 (0x00007f9880062000)
    * libtiff.so.5 => /usr/lib/x86_64-linux-gnu/libtiff.so.5 (0x00007f987fdf0000)
    * /lib64/ld-linux-x86-64.so.2 (0x00007f98811de000)
    * liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007f987fbce000)
    * libjbig.so.0 => /usr/lib/x86_64-linux-gnu/libjbig.so.0 (0x00007f987f9c0000)
    * libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f987f7bc000)
* ./fileinfo:
    * linux-vdso.so.1 =>  (0x00007fff1b9e9000)
    * ~~liblept.so.4 => /app/.vendor/leptonica-1.71/lib/liblept.so.4 (0x00007f3606d1d000)~~
    * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f3606958000)
    * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f3606652000)
    * libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f3606439000)
    * libpng12.so.0 => /lib/x86_64-linux-gnu/libpng12.so.0 (0x00007f3606213000)
    * libjpeg.so.8 => /usr/lib/x86_64-linux-gnu/libjpeg.so.8 (0x00007f3605fbe000)
    * libtiff.so.5 => /usr/lib/x86_64-linux-gnu/libtiff.so.5 (0x00007f3605d4c000)
    * /lib64/ld-linux-x86-64.so.2 (0x00007f360713a000)
    * liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007f3605b2a000)
    * libjbig.so.0 => /usr/lib/x86_64-linux-gnu/libjbig.so.0 (0x00007f360591c000)
    * libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f3605718000)
* ./printimage:
    * linux-vdso.so.1 =>  (0x00007ffc56be6000)
    * ~~liblept.so.4 => /app/.vendor/leptonica-1.71/lib/liblept.so.4 (0x00007f6694c25000)~~
    * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f6694860000)
    * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f669455a000)
    * libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f6694341000)
    * libpng12.so.0 => /lib/x86_64-linux-gnu/libpng12.so.0 (0x00007f669411b000)
    * libjpeg.so.8 => /usr/lib/x86_64-linux-gnu/libjpeg.so.8 (0x00007f6693ec6000)
    * libtiff.so.5 => /usr/lib/x86_64-linux-gnu/libtiff.so.5 (0x00007f6693c54000)
    * /lib64/ld-linux-x86-64.so.2 (0x00007f6695042000)
    * liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007f6693a32000)
    * libjbig.so.0 => /usr/lib/x86_64-linux-gnu/libjbig.so.0 (0x00007f6693824000)
    * libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f6693620000)
* ./printsplitimage:
    * linux-vdso.so.1 =>  (0x00007ffdd91c8000)
    * ~~liblept.so.4 => /app/.vendor/leptonica-1.71/lib/liblept.so.4 (0x00007f967765f000)~~
    * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f967729a000)
    * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f9676f94000)
    * libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f9676d7b000)
    * libpng12.so.0 => /lib/x86_64-linux-gnu/libpng12.so.0 (0x00007f9676b55000)
    * libjpeg.so.8 => /usr/lib/x86_64-linux-gnu/libjpeg.so.8 (0x00007f9676900000)
    * libtiff.so.5 => /usr/lib/x86_64-linux-gnu/libtiff.so.5 (0x00007f967668e000)
    * /lib64/ld-linux-x86-64.so.2 (0x00007f9677a7c000)
    * liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007f967646c000)
    * libjbig.so.0 => /usr/lib/x86_64-linux-gnu/libjbig.so.0 (0x00007f967625e000)
    * libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f967605a000)
* ./printtiff:
    * linux-vdso.so.1 =>  (0x00007ffde3cfe000)
    * ~~liblept.so.4 => /app/.vendor/leptonica-1.71/lib/liblept.so.4 (0x00007fae853ce000)~~
    * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fae85009000)
    * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007fae84d03000)
    * libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007fae84aea000)
    * libpng12.so.0 => /lib/x86_64-linux-gnu/libpng12.so.0 (0x00007fae848c4000)
    * libjpeg.so.8 => /usr/lib/x86_64-linux-gnu/libjpeg.so.8 (0x00007fae8466f000)
    * libtiff.so.5 => /usr/lib/x86_64-linux-gnu/libtiff.so.5 (0x00007fae843fd000)
    * /lib64/ld-linux-x86-64.so.2 (0x00007fae857eb000)
    * liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007fae841db000)
    * libjbig.so.0 => /usr/lib/x86_64-linux-gnu/libjbig.so.0 (0x00007fae83fcd000)
    * libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007fae83dc9000)
* ./splitimage2pdf:
    * linux-vdso.so.1 =>  (0x00007ffc8a8c7000)
    * ~~liblept.so.4 => /app/.vendor/leptonica-1.71/lib/liblept.so.4 (0x00007f19f90a9000)~~
    * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f19f8ce4000)
    * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f19f89de000)
    * libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f19f87c5000)
    * libpng12.so.0 => /lib/x86_64-linux-gnu/libpng12.so.0 (0x00007f19f859f000)
    * libjpeg.so.8 => /usr/lib/x86_64-linux-gnu/libjpeg.so.8 (0x00007f19f834a000)
    * libtiff.so.5 => /usr/lib/x86_64-linux-gnu/libtiff.so.5 (0x00007f19f80d8000)
    * /lib64/ld-linux-x86-64.so.2 (0x00007f19f94c6000)
    * liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007f19f7eb6000)
    * libjbig.so.0 => /usr/lib/x86_64-linux-gnu/libjbig.so.0 (0x00007f19f7ca8000)
    * libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f19f7aa4000)
* ./xtractprotos:
    * linux-vdso.so.1 =>  (0x00007fff97beb000)
    * ~~liblept.so.4 => /app/.vendor/leptonica-1.71/lib/liblept.so.4 (0x00007f1552489000)~~
    * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f15520c4000)
    * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f1551dbe000)
    * libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f1551ba5000)
    * libpng12.so.0 => /lib/x86_64-linux-gnu/libpng12.so.0 (0x00007f155197f000)
    * libjpeg.so.8 => /usr/lib/x86_64-linux-gnu/libjpeg.so.8 (0x00007f155172a000)
    * libtiff.so.5 => /usr/lib/x86_64-linux-gnu/libtiff.so.5 (0x00007f15514b8000)
    * /lib64/ld-linux-x86-64.so.2 (0x00007f15528a6000)
    * liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007f1551296000)
    * libjbig.so.0 => /usr/lib/x86_64-linux-gnu/libjbig.so.0 (0x00007f1551088000)
    * libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f1550e84000)

### tesseract-3.04.01
* ./tesseract
    * linux-vdso.so.1 =>  (0x00007fff85917000)
    * ~~libtesseract.so.3 => /app/.vendor/tesseract-3.04.01/lib/libtesseract.so.3 (0x00007ff2979a8000)~~
    * ~~liblept.so.4 => /app/.vendor/leptonica-1.71/lib/liblept.so.4 (0x00007ff29758b000)~~
    * libstdc++.so.6 => /usr/lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007ff297287000)
    * libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007ff297071000)
    * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007ff296cac000)
    * libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007ff296a8e000)
    * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007ff296788000)
    * libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007ff29656f000)
    * libpng12.so.0 => /lib/x86_64-linux-gnu/libpng12.so.0 (0x00007ff296349000)
    * libjpeg.so.8 => /usr/lib/x86_64-linux-gnu/libjpeg.so.8 (0x00007ff2960f4000)
    * libtiff.so.5 => /usr/lib/x86_64-linux-gnu/libtiff.so.5 (0x00007ff295e82000)
    * /lib64/ld-linux-x86-64.so.2 (0x00007ff298152000)
    * liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007ff295c60000)
    * libjbig.so.0 => /usr/lib/x86_64-linux-gnu/libjbig.so.0 (0x00007ff295a52000)
    * libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007ff29584e000)

### opencv-3.1.0
* not a dynamic executable

### ImageMagick-7.0.1-10
* ./magick:
    * linux-vdso.so.1 =>  (0x00007ffc4bf09000)
    * ~~libMagickCore-7.Q16HDRI.so.0 => /app/.vendor/ImageMagick-7.0.1-10/lib/libMagickCore-7.Q16HDRI.so.0 (0x00007fd4d19e0000)~~
    * ~~libMagickWand-7.Q16HDRI.so.0 => /app/.vendor/ImageMagick-7.0.1-10/lib/libMagickWand-7.Q16HDRI.so.0 (0x00007fd4d16b6000)~~
    * libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007fd4d1498000)
    * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fd4d10d3000)
    * libjbig.so.0 => /usr/lib/x86_64-linux-gnu/libjbig.so.0 (0x00007fd4d0ec5000)
    * liblcms2.so.2 => /usr/lib/x86_64-linux-gnu/liblcms2.so.2 (0x00007fd4d0c70000)
    * libtiff.so.5 => /usr/lib/x86_64-linux-gnu/libtiff.so.5 (0x00007fd4d09fe000)
    * libjpeg.so.8 => /usr/lib/x86_64-linux-gnu/libjpeg.so.8 (0x00007fd4d07a9000)
    * liblqr-1.so.0 => /usr/lib/x86_64-linux-gnu/liblqr-1.so.0 (0x00007fd4d0591000)
    * libpng12.so.0 => /lib/x86_64-linux-gnu/libpng12.so.0 (0x00007fd4d036b000)
    * libdjvulibre.so.21 => /usr/lib/x86_64-linux-gnu/libdjvulibre.so.21 (0x00007fd4cffd5000)
    * libfontconfig.so.1 => /usr/lib/x86_64-linux-gnu/libfontconfig.so.1 (0x00007fd4cfd99000)
    * libfreetype.so.6 => /usr/lib/x86_64-linux-gnu/libfreetype.so.6 (0x00007fd4cfaf6000)
    * libwmflite-0.2.so.7 => /usr/lib/x86_64-linux-gnu/libwmflite-0.2.so.7 (0x00007fd4cf8da000)
    * libXext.so.6 => /usr/lib/x86_64-linux-gnu/libXext.so.6 (0x00007fd4cf6c8000)
    * libX11.so.6 => /usr/lib/x86_64-linux-gnu/libX11.so.6 (0x00007fd4cf393000)
    * liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007fd4cf171000)
    * libbz2.so.1.0 => /lib/x86_64-linux-gnu/libbz2.so.1.0 (0x00007fd4cef61000)
    * libIlmImf.so.6 => /usr/lib/x86_64-linux-gnu/libIlmImf.so.6 (0x00007fd4cecb2000)
    * libxml2.so.2 => /usr/lib/x86_64-linux-gnu/libxml2.so.2 (0x00007fd4ce94b000)
    * libgvc.so.6 => /usr/lib/libgvc.so.6 (0x00007fd4ce6b0000)
    * libcgraph.so.6 => /usr/lib/libcgraph.so.6 (0x00007fd4ce49a000)
    * libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007fd4ce281000)
    * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007fd4cdf7b000)
    * libgomp.so.1 => /usr/lib/x86_64-linux-gnu/libgomp.so.1 (0x00007fd4cdd6c000)
    * libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007fd4cdb56000)
    * /lib64/ld-linux-x86-64.so.2 (0x00007fd4d20a3000)
    * libglib-2.0.so.0 => /lib/x86_64-linux-gnu/libglib-2.0.so.0 (0x00007fd4cd84e000)
    * libstdc++.so.6 => /usr/lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007fd4cd54a000)
    * libexpat.so.1 => /lib/x86_64-linux-gnu/libexpat.so.1 (0x00007fd4cd320000)
    * libxcb.so.1 => /usr/lib/x86_64-linux-gnu/libxcb.so.1 (0x00007fd4cd101000)
    * libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007fd4ccefd000)
    * libHalf.so.6 => /usr/lib/x86_64-linux-gnu/libHalf.so.6 (0x00007fd4cccba000)
    * libIex.so.6 => /usr/lib/x86_64-linux-gnu/libIex.so.6 (0x00007fd4cca9c000)
    * libIlmThread.so.6 => /usr/lib/x86_64-linux-gnu/libIlmThread.so.6 (0x00007fd4cc896000)
    * libltdl.so.7 => /usr/lib/x86_64-linux-gnu/libltdl.so.7 (0x00007fd4cc68c000)
    * libcdt.so.5 => /usr/lib/libcdt.so.5 (0x00007fd4cc485000)
    * libpathplan.so.4 => /usr/lib/libpathplan.so.4 (0x00007fd4cc27d000)
    * libpcre.so.3 => /lib/x86_64-linux-gnu/libpcre.so.3 (0x00007fd4cc03f000)
    * libXau.so.6 => /usr/lib/x86_64-linux-gnu/libXau.so.6 (0x00007fd4cbe3b000)
    * libXdmcp.so.6 => /usr/lib/x86_64-linux-gnu/libXdmcp.so.6 (0x00007fd4cbc35000)
* ./Magick++-config:
    * not a dynamic executable
* ./MagickCore-config:
    * not a dynamic executable
* ./MagickWand-config:
    * not a dynamic executable

[RequirementLibraries]: https://github.com/milabo/heroku-buildpack-focus/bin/lib/readme.md#RequirementLibraries
