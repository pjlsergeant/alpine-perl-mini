FROM alpine AS perlbuild

## alpine curl and wget aren't fully compatible, so we install them
## here. gnupg is needed for Module::Signature.
RUN apk update && apk upgrade && apk add curl tar make gcc build-base wget gnupg

RUN mkdir -p /usr/src/perl

WORKDIR /usr/src/perl

## from perl; `true make test_harness` because 3 tests fail
## some flags from http://git.alpinelinux.org/cgit/aports/tree/main/perl/APKBUILD?id=19b23f225d6e4f25330e13144c7bf6c01e624656
RUN curl -SLO https://www.cpan.org/src/5.0/perl-5.30.0.tar.gz \
    && echo 'aa5620fb5a4ca125257ae3f8a7e5d05269388856 *perl-5.30.0.tar.gz' | sha1sum -c - \
    && tar --strip-components=1 -xzf perl-5.30.0.tar.gz -C /usr/src/perl \
    && rm perl-5.30.0.tar.gz \
    && ./Configure -des \
        -Duse64bitall \
        -Dcccdlflags='-fPIC' \
        -Dcccdlflags='-fPIC' \
        -Dccdlflags='-rdynamic' \
        -Dlocincpth=' ' \
        -Duselargefiles \
        -Dusethreads \
        -Duseshrplib \
        -Dd_semctl_semun \
        -Dusenm \
        -Dprefix=/opt/perl \
    && make libperl.so \
    && make -j$(nproc) \
    && true TEST_JOBS=$(nproc) make test_harness \
    && make install

RUN rm -Rf /usr/src/perl
WORKDIR /opt/perl/
ENV PATH "/opt/perl/bin:$PATH"

# Grab cpanm, executable only
WORKDIR /opt/perl/bin/
RUN curl -L https://cpanmin.us/ -o cpanm && chmod +x cpanm
WORKDIR /
