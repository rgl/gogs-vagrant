#!/bin/bash
set -eux
export GOPATH=$PWD/gopath
export PATH=$GOPATH/bin:$PATH
if [ ! -d $GOPATH/src/github.com/gogits/gogs ]; then
  mkdir -p $GOPATH/{src,pkg,bin}
  git clone -b v0.11.29 https://github.com/gogits/gogs $GOPATH/src/github.com/gogits/gogs
  sed -i -E 's/(\s+)(cmd.Admin,)/\1\2\n\1cmd.CreateAdminUser,/' $GOPATH/src/github.com/gogits/gogs/gogs.go
  ln -s /vagrant/create-admin-user.go $GOPATH/src/github.com/gogits/gogs/cmd/
fi
if [ ! -f $GOPATH/bin/go-bindata ]; then
  go get -v github.com/jteeuwen/go-bindata/...
fi
pushd $GOPATH/src/github.com/gogits/gogs
go env
make build
popd
