#!/bin/bash

set -e

: "${PLUGIN_PORT:=22}"
: "${PLUGIN_SOURCE:=./}"
: "${PLUGIN_TARGET_REPO:=false}"
: "${PLUGIN_TARGET_BRANCH:=false}"

if [[ -z "$PLUGIN_REMOTE" ]]; then
    printf "Remote host not set.\n"
    exit 1
fi

if [[ -z "$PLUGIN_TARGET" ]]; then
    printf "Remote target not set.\n"
    exit 1
fi

if [[ -z "$PLUGIN_USERNAME" ]]; then
    printf "Remote user not set.\n"
    exit 1
fi

if [[ -z "$PLUGIN_PASSWORD" ]]; then
    printf "Remote password not set.\n"
    exit 1
fi

if [[ -z "$PLUGIN_ARGS" ]]; then
    PLUGIN_ARGS="-avz --delete"
fi

EXPR="rsync $PLUGIN_ARGS"
EXPR="$EXPR -e 'sshpass -p $PLUGIN_PASSWORD ssh -p $PLUGIN_PORT -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o StrictHostKeyChecking=no'"

IFS=','; read -ra INCLUDE <<< "$PLUGIN_INCLUDE"
for include in "${INCLUDE[@]}"; do
    EXPR="$EXPR --include=$include"
done

IFS=','; read -ra EXCLUDE <<< "$PLUGIN_EXCLUDE"
for exclude in "${EXCLUDE[@]}"; do
    EXPR="$EXPR --exclude=$exclude"
done

IFS=','; read -ra FILTER <<< "$PLUGIN_FILTER"
for filter in "${FILTER[@]}"; do
    EXPR="$EXPR --filter=$filter"
done

EXPR="$EXPR $PLUGIN_SOURCE"

if [ "$PLUGIN_TARGET_REPO" == true ]; then
    PLUGIN_TARGET="$PLUGIN_TARGET/$CI_REPO"
fi

if [ "$PLUGIN_TARGET_BRANCH" == true ] && [ "$CI_COMMIT_BRANCH" != "$CI_REPO_DEFAULT_BRANCH" ]; then
    PLUGIN_TARGET="$PLUGIN_TARGET.$CI_COMMIT_BRANCH"
fi

eval "$EXPR $PLUGIN_USERNAME@$PLUGIN_REMOTE:$PLUGIN_TARGET"
