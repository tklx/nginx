## Install dependencies

```console
git clone https://github.com/tklx/bats.git
bats/install.sh /usr/local
```

## Run the tests

```console
IMAGE=tklx/nginx bats --tap tests/basics.bats

init: running tklx/nginx

1..1

ok 1 port 80 accepts connections
```

