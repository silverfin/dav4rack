#!/bin/sh 

# Run builtin spec tests
docker compose up -d
bundle exec rake
docker compose down

if [ $? -ne 0 ] ; then
  echo "*** Specs failed to properly complete"
  exit 1
fi

echo "*** Specs passed. Starting litmus"
echo

# Ensure fresh store directory
rm -rf /tmp/dav-file-store
mkdir /tmp/dav-file-store

# Run litmus test
bundle exec dav4rack --root /tmp/dav-file-store &

# Allow time for dav4rack to get started
sleep 3

DAV_PID=$?

if [ ! -d /tmp/litmus/litmus-0.14 ]; then
  mkdir /tmp/litmus
  git clone --recurse-submodules https://github.com/notroj/litmus.git /tmp/litmus/litmus-0.14/
  cd /tmp/litmus/litmus-0.14
  git checkout tags/0.14
  ./autogen.sh
  ./configure
fi

cd /tmp/litmus/litmus-0.14
make URL=http://localhost:3000/ check

LITMUS=$?

kill $DAV_PID

if [ $? -ne 0 ] ; then
  echo
  echo "*** Litmus failed to properly complete"
  exit 1
fi
