#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}")/.. && pwd)
cd $ROOT
source $ROOT/hack/lib.sh

function usage() {
    local name=$(basename $0)
    printf "Usage: %s [options] <hostpattern> <scriptfile>\n" $name
    printf "\n"
    printf "Examples:\n"
    printf "  %s all scripts/kubeletversion.sh\n" $name
    printf "  %s jq3 scripts/kubeletversion.sh\n" $name
}

while getopts "h?" opt; do
    case "$opt" in
        h|\?)
            usage
            exit 0
            ;;
    esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

hostpattern=$1
script=$ROOT/$2
shift 2

if [ ! -e "$script" ]; then
    echo "error: $script not found"
    exit 1
fi

INVENTORY=output/all.ini
$ROOT/hack/gen-ansible-inventory.sh > $INVENTORY

src=$script
dst=/tmp/ansbile.script.$$
ansible -f 5 -i $INVENTORY $hostpattern -m copy -a "src=$src dest=$dst"
ansible -f 1 -i $INVENTORY $hostpattern -m shell -a "bash $dst $@"
