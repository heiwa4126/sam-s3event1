#!/bin/bash -ue
. ./tmp_env.sh

sam logs --name HelloFunction --stack-name "$SS_STACK_NAME" --tail &
