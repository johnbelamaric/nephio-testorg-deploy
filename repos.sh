#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2022
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

#
# GH_TOKEN is set or ~/nephio-test-github-pat.txt exists.
#
set -o pipefail
set -o errexit
set -o nounset
DEBUG=${DEBUG:-false}
if [[ $DEBUG == "true" ]]; then
    set -o xtrace
fi

function usage {
    echo "usage: $0 { create | delete } participant ..."
    exit 1
}

if [[ $# -lt 2 ]]; then
    usage
fi

if ! command -v gh >/dev/null; then
    curl -s 'https://i.jpillora.com/cli/cli!?as=gh' | bash
fi

cmd=$1
shift

if [[ $cmd == "create" ]]; then
    gh="gh repo create --public "
elif [[ $cmd == "delete" ]]; then
    gh="gh repo delete --yes "
else
    usage
fi

if [[ $DEBUG == "true" ]]; then
    gh="echo $gh"
fi

token_file="$HOME/nephio-test-github-pat.txt"
export GH_TOKEN=${GH_TOKEN-}

if [[ -z $GH_TOKEN && -f $token_file ]]; then
    GH_TOKEN=$(<"$token_file")
fi

if [[ -z $GH_TOKEN ]]; then
    echo "GH_TOKEN must be set or $token_file must contain it"
    exit 1
fi

repos=($(basename -s .yaml *.yaml))

for p in "$@"; do
    for r in "${repos[@]}"; do
        $gh "$p-$r" || echo 
    done
done
