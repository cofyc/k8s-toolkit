#!/bin/bash

tmpdir=$(mktemp -d)
trap "rm -r $tmpdir" EXIT

cd $tmpdir
wget -q https://raw.githubusercontent.com/cofyc/CVE/aea228ca659df702e142f7b064460f696b2d9480/CVE-2019-5736/patch_runc.sh
bash patch_runc.sh
