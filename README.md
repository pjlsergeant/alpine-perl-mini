# What

Alpine + Perl 5.32.0 - build cruft

This repo builds Alpine Linux + Perl 5.32.0. The general ideas is https://github.com/scottw/alpine-perl but installs Perl in a specified directory, so you can just yank it once it's built and start again.

# Use It

Use it like this:

```
FROM pjlsergeant/alpine-perl-mini AS build

#
# INSTALL YOUR MODULE DEPENDENCIES HERE!!!
#

RUN apk add mysql-dev
RUN cpanm DBD::mysql

# Grab Perl. You don't need to touch this bit.
FROM alpine AS production
COPY --from=build /opt/perl/ /opt/perl/

#
# GRAB ANY SYSTEM LIBRARIES YOU NEEDED
#

RUN apk add mariadb-connector-c

# Optionally put Perl back in your path
ENV PATH "/opt/perl/bin:$PATH"
```

# Build It

`docker pull alpine` # make sure you've got the latest alpine

`docker image build -t pjlsergeant/alpine-perl-mini:latest .`

`docker push pjlsergeant/alpine-perl-mini:latest`

# Why?

This allows for significantly smaller containers, and also ones without build cruft included, by virtue of being able to just grab the dir that Perl is installed in. See [this issue](https://github.com/scottw/alpine-perl/issues/5). The container built by:

```
FROM pjlsergeant/alpine-perl-mini AS build
RUN cpanm RTF::Tokenizer
FROM alpine AS production
COPY --from=build /opt/perl/ /opt/perl/
```

is 60 MB as compared to the 316 MB container from:

```
FROM scottw/alpine-perl
RUN cpanm RTF::Tokenizer
```

It comes with the disadvantage that I am using this for my personal stuff, so no guarantees about anything. I recommend simply stealing the Dockerfile and method I'm using it and using it for your own purposes directly.

