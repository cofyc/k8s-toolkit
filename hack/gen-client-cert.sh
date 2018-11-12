#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}")/.. && pwd)
cd $ROOT
source $ROOT/hack/lib.sh

CN=$1
O=$2

hack::gencert $DEFAULT_APISERVER_CA_CRT $DEFAULT_APISERVER_CA_KEY "$CN" "$O"
