rvm-package
===========

RVM packaging in Docker container: creates RPM containing RVM, specified ruby
versions and ruby gems.

Dependencies
------------

You only need docker installed:

    $ docker -v
    Docker version 1.6.2, build 7c8fca2

Usage
-----

Build docker image:

    $ docker build -t rvm-package .

Create output directory for resulting RPM file:

    $ rm -rf out && mkdir -p out

Run docker container from rvm-package image:

    $ docker run \
        -e RVM_USER=test \
        -e RVM_GROUP=test \
        -e RVM_USER_HOME=/home/test \
        -e RUBY_VERSIONS=1.9.3,2.2.1 \
        -e RUBY_GEMS=rake,bundler \
        -e PACKAGE_NAME=rvm-test \
        -e PACKAGE_VERSION=1 \
        -v $(pwd)/out:/tmp/out \
        rvm

    # Resulting RPM
    $ ls -lh ./out
    -rw-rw-r-- 1 test test 91M Jul 24 14:03 rvm-test-1-1437746402.noarch.rpm

Install resulting RPM package on target machine:

    $ su test
    $ sudo rpm -ivh rvm-test-1-1437746402.noarch.rpm
    $ source ~/.bash_profile
    $ rvm 1.9.3
