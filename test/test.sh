#!/usr/bin/env bash

thor foodcritic:lint -f any || exit 1
thor tailor:lint || exit 1
knife cookbook test -o ../ $(basename $PWD) || exit 1
rspec || exit 1
kitchen test "default-vagrant-*"
