# Environment

This [vagrant](https://www.vagrantup.com/) environment configures a basic [Gogs](https://gogs.io/) installation with a local [PostgreSQL](http://www.postgresql.org/) database.

[Nginx](http://nginx.org/en/) ([HTTP/2](https://en.wikipedia.org/wiki/HTTP/2) enabled) is configured with a self-signed certificate at:

> https://git.example.com/

Gogs is installed at: 

    /
    |-- home/
    |   `-- git/                      git user home
    |       |-- .ssh/                 gogs managed ssh settings
    |       `-- gogs-repositories/    gogs managed git repositories
    `-- opt/
        `-- gogs/                     gogs application home
            |   ...
            |-- log/                  gogs logs (and journald)
            `-- app.ini               gogs configuration


This targets the [`develop` branch](https://github.com/gogits/gogs/tree/develop) of gogs. You can change this by modifying the [`build-gogs.sh`](build-gogs.sh) file.


# Usage

Configure your host system to resolve the `git.example.com` domain to this vagrant environment IP address, e.g.:

```sh
echo '192.168.33.10 git.example.com' | sudo tee -a /etc/hosts
```

Sign In into Gogs using the `gogs` username and the `password` password at:

> https://git.example.com/user/login

Add your [public SSH key](https://git-scm.com/book/en/v2/Git-on-the-Server-Generating-Your-SSH-Public-Key) into Gogs, for that open your Gogs profile SSH keys page at:

> https://git.example.com/user/settings/ssh

Add a new SSH key with your SSH public key, for that, just copy the contents of
your `id_rsa.pub` file. Get its contents with, e.g.:

```sh
cat ~/.ssh/id_rsa.pub
```

Create a new repository named `hello` at:

> https://git.example.com/repo/create

You can now clone that repository with SSH or HTTPS:

```sh
git clone git@git.example.com:gogs/hello.git
GIT_SSL_NO_VERIFY=true git clone https://gogs@git.example.com/gogs/hello.git
```

**NB** This vagrant environment does not have a proper SSL certificate, as such,
HTTPS cloning will fail with `SSL certificate problem: self signed certificate`.
To temporarily ignore that error we set the [`GIT_SSL_NO_VERIFY=true` environment
variable](https://git-scm.com/book/en/v2/Git-Internals-Environment-Variables).

Make some changes to the cloned repository and push them:

```sh
cd hello
echo '# Hello World' >> README.md
git add README.md
git commit -m 'some change'
GIT_SSL_NO_VERIFY=true git push
```
