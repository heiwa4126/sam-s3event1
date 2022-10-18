#!/bin/bash -ue
# AWS SAMの設定からstackのoutputをbashのshell風に書き出す

ENVFILE=./tmp_env.sh

## required tomlq in yq. Try `apt install jq` and `pip3 install yq`
REGION=$(tomlq -r .default.deploy.parameters.region samconfig.toml)
STACK_NAME=$(tomlq -r .default.deploy.parameters.stack_name samconfig.toml)

stack_info=$(aws cloudformation describe-stacks --output json --no-cli-pager \
  --region "$REGION" \
  --stack-name "$STACK_NAME")

# original at https://gist.github.com/JCotton1123/e0203791aae37f22b27dfce2c7002dbf
# and see: https://www.baeldung.com/linux/reading-output-into-array
rm -f "$ENVFILE"

echo "export SS_REGION=\"$REGION\"" >>$ENVFILE
echo "export SS_STACK_NAME=\"$STACK_NAME\"" >>$ENVFILE

# outputs

if [[ "$stack_info" =~ "OutputKey" ]]; then
  IFS=$'\n' read -r -d '' -a output_keys < <(echo "$stack_info" | jq ".Stacks[].Outputs[].OutputKey" && printf '\0')
  IFS=$'\n' read -r -d '' -a output_vals < <(echo "$stack_info" | jq ".Stacks[].Outputs[].OutputValue" && printf '\0')

  for ((i = 0; i < ${#output_keys[@]}; ++i)); do
    key=$(echo "${output_keys[i]}" | sed -e 's/^"//' -e 's/"$//')
    val=$(echo "${output_vals[i]}" | sed -e 's/^"//' -e 's/"$//')
    echo "export SO_$key=\"$val\"" >>$ENVFILE
  done
fi
