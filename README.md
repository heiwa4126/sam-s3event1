# sam-s3event1

S3イベントをトリガにしてlambdaを起動する。
だがそのlambdaはイベント元のS3に依存している、という場合、
1つのスタックを2回にわけてデプロイしないといけない、
というSAMのサンプル。

参考:
[AWS::S3::Bucket NotificationConfiguration - AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-notificationconfig.html) の冒頭のnote参照。

上記該当部分の機械翻訳(DeepL)
> 対象リソースと関連するパーミッションを同じテンプレートで作成した場合、循環的な依存関係が発生する可能性があります。
>
> 例えば、AWS::Lambda::Permissionリソースを使用して、バケットにAWS Lambda関数を呼び出す権限を付与することができます。しかし、AWS CloudFormationはバケットに関数を呼び出す権限がないとバケットを作成できません（AWS CloudFormationはバケットが関数を呼び出すことができるかどうかをチェックします）。Refsを使ってバケット名を渡している場合、これは循環依存につながります。
>
> この依存関係を回避するには、通知設定を指定せずにすべてのリソースを作成します。その後、通知設定を使ってスタックを更新します。


# デプロイ

```bash
sam build
sam deploy -t template0.yaml --guided  # 2回目からは--guidedぬきでOK
sam deploy
```


# テスト

デプロイ終了後

```bash
./make_env.sh  # デプロイ毎に1回実行
./tail_samlog.sh  # tmuxなどで別ペインで実行するのがおすすめ
```

で、
```bash
./put_s3.sh
```
すると、しばらく(10秒ぐらい?)たってから最新ログが表示される。


```bash
./rm_s3.sh && ./put_s3.sh
```
で何度でもテストできる。


# スタックの削除

```bash
./stop_samlog.sh
./rm_s3.sh
sam delete --no-prompts
```


# ポイント

template.yaml も
template0.yaml も
循環依存(circular dependency)があってはいけない。
事前に [cfn-lint](https://github.com/aws-cloudformation/cfn-lint)でチェックしておくべき。

このケースでは
[AWS::Serverless::Function](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/sam-resource-function.html#sam-function-events) の
[S3イベント](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-property-function-s3.html)
も使えない。


# TODO

template.yaml から
template0.yaml を自動生成できるような工夫を考えること

あとTerraformではどうなのか確認すること。
