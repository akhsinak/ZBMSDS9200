# セキュリティと認可

このドキュメントでは、ローカルメールアプリケーションのセキュリティと認可メカニズムについて説明します。

## 概要

このアプリケーションは、SAP BTP（Business Technology Platform）環境用に設計された包括的なセキュリティモデルを使用します。

## 認証

### SAP XSUAA（Extended Services for User Account and Authentication）

このアプリケーションは、SAP XSUAAサービスを使用して認証と認可を処理します。

| 機能 | 説明 |
|------|------|
| **OAuth 2.0** | OAuth 2.0プロトコルを使用したトークンベースの認証 |
| **JWTトークン** | JSON Webトークンによる安全な情報交換 |
| **SAML統合** | 企業アイデンティティプロバイダーとの統合 |
| **セッション管理** | セキュアなユーザーセッション処理 |

### XSUAAサービスバインディング

```yaml
# mta.yaml内のリソース定義
resources:
  - name: emailapp2-uaa
    type: org.cloudfoundry.managed-service
    parameters:
      service: xsuaa
      service-plan: application
```

## 認可

### ロールベースアクセス制御（RBAC）

このアプリケーションは、ロールベースのアクセス制御を実装しています。

| ロール | 説明 | スコープ |
|--------|------|---------|
| `EmailViewer` | メールの表示のみ | `uaa.user`, `$XSAPPNAME.Display` |
| `EmailAdmin` | メールの完全管理 | `uaa.user`, `$XSAPPNAME.Display`, `$XSAPPNAME.Update` |

### xs-security.json設定

```json
{
  "xsappname": "emailapp2",
  "tenant-mode": "dedicated",
  "scopes": [
    {
      "name": "$XSAPPNAME.Display",
      "description": "メールの表示"
    },
    {
      "name": "$XSAPPNAME.Update",
      "description": "メールの作成・更新・削除"
    }
  ],
  "role-templates": [
    {
      "name": "EmailViewer",
      "description": "メールの表示",
      "scope-references": [
        "uaa.user",
        "$XSAPPNAME.Display"
      ]
    }
  ]
}
```

## ユーザースコープデータアクセス

### 行レベルセキュリティ

このアプリケーションは、行レベルのセキュリティを実装しており、ユーザーは自分が作成したメールのみを表示できます。

#### 実装アプローチ

1. **所有者フィールド**: `Emails`エンティティには、レコードを作成したユーザーを追跡する`owner`フィールドがあります。

2. **自動フィルタリング**: サービスレイヤーは、リクエストを現在のユーザーのレコードのみに自動的にフィルタリングします。

### 技術的実装

```cds
// データベーススキーマ
entity Emails : managed {
    key ID          : UUID;
    emailAddress    : String(255);
    owner           : String(255); // 作成者ユーザーID
}
```

## アプリケーションローター（App Router）

### セキュリティゲートウェイ

SAPアプリケーションローターは、次の役割を果たします：

| 機能 | 説明 |
|------|------|
| **認証フロー** | OAuth 2.0認証コードフローの処理 |
| **JWT検証** | 受信トークンの検証 |
| **ルーティング** | ユーザーを適切なサービスにルーティング |
| **セッション管理** | ユーザーセッションの管理 |

### xs-app.json設定

```json
{
  "welcomeFile": "/app/browse/webapp/index.html",
  "authenticationMethod": "route",
  "routes": [
    {
      "source": "^/odata/v4/email/(.*)$",
      "target": "/odata/v4/email/$1",
      "destination": "emailapp2-srv",
      "authenticationType": "xsuaa"
    }
  ]
}
```

## デプロイメント時のセキュリティ

### 環境変数

セキュアな設定は環境変数として保存されます：

| 変数 | 説明 |
|------|------|
| `VCAP_SERVICES` | バインドされたサービス認証情報 |
| ` destinations` | 宛先設定 |

### 機密情報の処理

- パスワードやAPIキーは`xs-security.json`または環境変数に保存されません
- 代わりに、XSUAAサービスバインディングを介して管理されます
- 開発時は`default-env.json`を使用（本番環境では.gitignore）

## 関連ドキュメント

- [設定ファイル](configuration-files.md) - セキュリティ設定ファイル
- [デプロイメント](deployment.md) - セキュアなデプロイメントプロセス
- [データベースレイヤー](database-layer.md) - データモデルと所有者フィールド
