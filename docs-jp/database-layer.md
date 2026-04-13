# データベースレイヤー

このドキュメントでは、ローカルメールアプリケーションのデータベースレイヤーを説明します。

## 概要

データベースレイヤーは`db/`フォルダにあり、アプリケーションデータモデルとスキーマ定義を含んでいます。

## ファイル構造

```
db/
└── schema.cds          # CDSエンティティ定義
```

## エンティティ定義

### Emailsテーブル

メールエントリのメインデータエンティティ：

```cds
entity Emails : managed {
    key ID          : UUID;
    emailAddress    : String(255) @title : 'メールアドレス';
    emailType       : String(50)  @title : 'メールタイプ';
    owner           : String(255) @title : '所有者';
}
```

| フィールド | タイプ | 説明 |
|-----------|--------|------|
| `ID` | UUID | 主キー - メールエントリの一意識別子 |
| `emailAddress` | String(255) | 実際のメールアドレス（user@example.comなど） |
| `emailType` | String(50) | メールアドレスのタイプまたは分類 |
| `owner` | String(255) | メールエントリを作成したユーザーのID |

## Managedアスペクト

`Emails`エンティティはCAPの組み込み`managed`アスペクトを拡張しています。これは自動的に以下のフィールドを提供します：

| フィールド | 説明 |
|-----------|------|
| `createdAt` | レコードが作成された日時 |
| `createdBy` | レコードを作成したユーザーのID |
| `modifiedAt` | レコードが最後に変更された日時 |
| `modifiedBy` | 最後の変更を行ったユーザーのID |

## 技術的実装詳細

### CDSファイルパース
`schema.cds`ファイルは、CDS（Core Data Services）定義言語を使用してドメインモデルを定義します：

```cds
using {managed} from '@sap/cds/common';

namespace my.emailapp2;

entity Emails : managed {
    key ID          : UUID;
    emailAddress    : String(255);
    emailType       : String(50);
    owner           : String(255);
}
```

### キー特性

1. **ユーザースコーピング**: `owner`フィールドにより、ユーザーは自分が作成したメールのみを表示できます
2. **監査追跡**: `managed`アスペクトは自動的に作成/変更メタデータを提供します
3. **SAP HANA Cloud**: 本番環境で使用されるデータベース

## 関連ドキュメント

- [サービスレイヤー](service-layer.md) - サービスがどのようにデータにアクセスするか
- [設定ファイル](configuration-files.md) - データベース接続設定
- [セキュリティと認可](security.md) - データアクセス制御
