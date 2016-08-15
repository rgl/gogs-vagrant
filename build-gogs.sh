#!/bin/bash
set -eux
export GOPATH=$PWD/gopath
export PATH=$GOPATH/bin:$PATH
if [ ! -d $GOPATH/src/github.com/gogits/gogs ]; then
  mkdir -p $GOPATH/{src,pkg,bin}
  git clone -b develop https://github.com/gogits/gogs $GOPATH/src/github.com/gogits/gogs
  sed -i -E 's/cmd.CmdCert,/cmd.CmdCert,cmd.CmdCreateAdminUser,/' $GOPATH/src/github.com/gogits/gogs/gogs.go 
  ln -s /vagrant/create-admin-user.go $GOPATH/src/github.com/gogits/gogs/cmd/
fi
if [ ! -f $GOPATH/bin/glide ]; then
  git clone -b v0.11.1 https://github.com/Masterminds/glide $GOPATH/src/github.com/Masterminds/glide
  cd $GOPATH/src/github.com/Masterminds/glide
  make build
  go install
fi
if [ ! -f $GOPATH/bin/go-bindata ]; then
  go get -v github.com/jteeuwen/go-bindata/...
fi
pushd $GOPATH/src/github.com/gogits/gogs
go env
glide install
make build
popd
