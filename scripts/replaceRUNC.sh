#!/bin/bash

tmpdir=$(mktemp -d)
trap "rm -r $tmpdir" EXIT

cd $tmpdir
wget -q https://raw.githubusercontent.com/cofyc/CVE/9d6be0d5d00a037ae8fa201ae2cd4dc31ded7750/CVE-2019-5736/patch_runc.sh
bash patch_runc.sh
