#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}")/.. && pwd)
cd $ROOT
source $ROOT/hack/lib.sh

SERVER=$1
shift

O=system:nodes
for node in $@; do
    CN=system:node:$node
	hack::gencert $DEFAULT_APISERVER_CA_CRT $DEFAULT_APISERVER_CA_KEY "$CN" "$O"
    hack::genkubeconfig "$SERVER" "$CN"
done
