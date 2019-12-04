# What

Alpine + Perl 5.30.0 - build cruft

This repo builds Alpine Linux + Perl 5.30.0. It's based on https://github.com/scottw/alpine-perl but installs Perl in a specified directory, so you can just yank it once it's built and start again.

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

`docker image build -t pjlsergeant/alpine-perl-mini:latest .`
`docker push pjlsergeant/alpine-perl-mini:latest`