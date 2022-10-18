#!/bin/bash -ue
# template.yamlからtmp0.yamlを作るサンプル
# 末尾に `#1#`が入っている行を除去するだけ。
# 状況に応じてアレンジしてください。

grep -vE '#1#\s*$' template.yaml > tmp0.yaml
