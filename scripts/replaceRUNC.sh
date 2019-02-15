#!/bin/bash

tmpdir=$(mktemp -d)
trap "rm -r $tmpdir" EXIT

cd $tmpdir
wget -q https://raw.githubusercontent.com/cofyc/CVE/ce5920f141dd9f9b8d0c868884ae66267dbdd6fa/CVE-2019-5736/patch_runc.sh
bash patch_runc.sh
