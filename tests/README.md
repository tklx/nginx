## Install dependencies

```console
git clone https://github.com/sstephenson/bats.git
bats/install.sh /usr/local
```

## Run the tests

```console
IMAGE=tklx/nginx bats --tap tests/basics.bats

init: running tklx/mongodb
init: waiting for tklx/mongodb to accept connections...
1..13
ok 1 db.test is empty
ok 2 db.test create entry and verify
ok 3 db.test overwrite entry and verify
ok 4 db.test find key and verify value
ok 5 db.test2 is empty
ok 6 db.test2 create entry and verify
ok 7 db.test count verify
ok 8 db.test2 drop and verify
ok 9 db.test count verify
ok 10 db.test count verify
ok 11 db.test count verify
ok 12 nonexistent database
ok 13 drop database and verify
```

