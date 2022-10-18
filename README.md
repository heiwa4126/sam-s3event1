# sam-s3event1

S3イベントをトリガにしてlambdaを起動する。
だがそのlambdaはイベント元のS3に依存している、という場合、
1つのスタックを2回にわけてデプロイしないといけない、
というSAMのサンプル。

参考:
[AWS::S3::Bucket NotificationConfiguration - AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-notificationconfig.html) の冒頭のnote参照。

# デプロイ

```bash
sam build
sam deploy --guided  # 2回目からは--guidedぬきでOK
sam deploy -t template2.yaml
```

# テスト

デプロイ終了後

```bash
./nake_env.sh  # デプロイ毎に1回実行
./put_s3.sh
```
でログを見る。




# ポイント

template.yaml も
template2.yaml も
循環依存(circular dependency)があってはいけない。
事前に [cfn-lint](https://github.com/aws-cloudformation/cfn-lint)でチェックしておくべき。

このケースでは
[AWS::Serverless::Function](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/sam-resource-function.html#sam-function-events) の
[S3イベント](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-property-function-s3.html)
も使えない。


# TODO

template2.yaml から
template.yaml を自動生成できるような工夫を考えること
(template.yaml から template2.yaml ではなく)。
