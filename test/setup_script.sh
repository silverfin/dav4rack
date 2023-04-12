#!/bin/sh

set -e

rm -rf /tmp/litmus
mkdir /tmp/litmus
git clone --recurse-submodules https://github.com/notroj/litmus.git /tmp/litmus/litmus-0.14/
cd /tmp/litmus/litmus-0.14
git checkout tags/0.14
./autogen.sh
./configure
