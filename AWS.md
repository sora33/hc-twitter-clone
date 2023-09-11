## 必要なリソース
- VPC
  - port: 10.1.0.0/16
  - subnet 
    - public: 10.1.0.0/24
    - public: 10.1.1.0/24
    - private: 10.1.2.0/16
    - private: 10.1.3.0/16
  - NAT gateway * 1
  - セキュリティグループ
    - ALB用
      - インバウンドルール
        - port: 443/80
    - ECS用
      - インバウンドルール
        - port: 3000(railsのデフォルト)
    - RDS用
      - インバウンドルール
        - port: 3306, source: ECSのアクセス
- RDS
  - Engine: PostgreSQL
  - InstanceClass: db.t2.micro
  - username: 
  - password:
  - db_name
  - db_subnet_groups
    - 2 private subnet
- ALB
  - 
- ECR
- ECS
- Route53

## 手順
1. ネットワーク（VPC等）を作成
2. セキュリティーグループを作成
3. ドメイン取得
4. RDS作成
5. ECS作成
6. ALB作成


aws ecs list-tasks --cluster ProjectA-ecs-cluster --service ProjectA-esc-service2	




{
    "taskArns": [
        "arn:aws:ecs:ap-northeast-1:925173743335:task/ProjectA-ecs-cluster/55ed705df13542b38a8f21e58c3c22b0",
        "arn:aws:ecs:ap-northeast-1:925173743335:task/ProjectA-ecs-cluster/bc92b559606a4ef39c842766ba386de1"
    ]
}
(END)

aws ecs execute-command --cluster react-rails-fargate-cluster-2 --task c9a63c8edd8b49e5bf27c5700cd51fa4 --interactive --command "rails c"
