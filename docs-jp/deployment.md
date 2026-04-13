# デプロイメント

このドキュメントでは、ローカルメールアプリケーションをSAP Business Technology Platform（BTP）にデプロイする方法について説明します。

## 概要

このアプリケーションは、SAP BTP Cloud Foundry環境にデプロイされるように設計されています。

## 前提条件

### 必要なツール

| ツール | バージョン | 目的 |
|--------|-----------|------|
| Node.js | 20.x | CAP開発 |
| Cloud Foundry CLI | 最新 | CFコマンド |
| MTAビルドツール | 最新 | マルチターゲットアプリケーションビルド |
| SAP CDS-DK | 最新 | CAP開発キット |

### SAP BTP設定

1. **SAP BTPアカウント** - サブアカウントとスペースへのアクセス
2. **HANA Cloudインスタンス** - SAP HANA Cloudデータベース
3. **XSUAAサービスインスタンス** - 認証設定
4. **Cloud Foundry権限** - デプロイメント権限

## ビルドプロセス

### ステップ1: 依存関係のインストール

```bash
npm install
```

### ステップ2: MTAビルド

```bash
mbt build
```

これにより、`mta_archives/`フォルダに`emailapp2_1.0.2.mtar`ファイルが作成されます。

### ステップ3: デプロイメント前の検証

```bash
# ビルドされたアーカイブの確認
ls -la mta_archives/

# マニフェストの検証
mta.yamlの構文を確認
```

## CFデプロイメント

### ステップ1: Cloud Foundryへのログイン

```bash
cf login -a https://api.cf.us10.hana.ondemand.com
```

### ステップ2: MTARのデプロイ

```bash
cf deploy mta_archives/emailapp2_1.0.2.mtar
```

または、ワイルドカードを使用：

```bash
cf deploy mta_archives/*.mtar
```

### ステップ3: 個別モジュールへのデプロイ（オプション）

```bash
# データベースのみデプロイ
cf deploy mta_archives/*.mtar -m emailapp2-db-deployer

# サービスのみデプロイ
cf deploy mta_archives/*.mtar -m emailapp2-srv

# アプリケーションローターのみデプロイ
cf deploy mta_archives/*.mtar -m emailapp2-approuter
```

## デプロイメント後の検証

### ステップ1: アプリケーションステータスの確認

```bash
# デプロイされたアプリケーションの一覧
cf apps

# サービスインスタンスの確認
cf services
```

### ステップ2: アプリケーションログの確認

```bash
# サービスモジュールのログ
cf logs emailapp2-srv --recent

# アプリケーションローターのログ
cf logs emailapp2-approuter --recent
```

### ステップ3: アプリケーションへのアクセス

デプロイ後、次のURLでアプリケーションにアクセスできます：

- **アプリケーションローター**: `https://<approuter-url>.cfapps.us10.hana.ondemand.com`
- **ODataサービス**: `https://<approuter-url>.cfapps.us10.hana.ondemand.com/odata/v4/email/`

## アプリケーションローター

### App Routerの役割

SAPアプリケーションローターは、次の機能を提供します：

| 機能 | 説明 |
|------|------|
| **認証** | XSUAA統合によるOAuth 2.0フロー |
| **ルーティング** | ユーザーを適切なサービスにルーティング |
| **セキュリティ** | JWTトークンの検証と処理 |

### 設定

App Routerは、自動的に提供された`xs-app.json`を介して設定されます：

```json
{
  "welcomeFile": "/app/browse/webapp/index.html",
  "authenticationMethod": "route",
  "routes": [
    {
      "source": "^/odata/v4/email/(.*)$",
      "destination": "emailapp2-srv",
      "authenticationType": "xsuaa"
    }
  ]
}
```

## トラブルシューティング

### 一般的な問題

| 問題 | 解決策 |
|------|--------|
| HANAサービスが見つからない | `cf create-service hana hdi-shared emailapp2-hana` |
| XSUAAサービスが見つからない | `cf create-service xsuaa application emailapp2-uaa` |
| デプロイメント失敗 | `cf logs <app-name> --recent`でログを確認 |
| データベース接続エラー | HANA Cloudインスタンスが実行中であることを確認 |

### HANA Cloud管理

```bash
# HANAインスタンスの停止
cf stop-emailapp2-hana

# HANAインスタンスの開始
cf start-emailapp2-hana

# HANAインスタンスの確認
cf service emailapp2-hana
```

## 関連ドキュメント

- [設定ファイル](configuration-files.md) - デプロイメント設定
- [セキュリティと認可](security.md) - XSUAAと認証設定
- [コマンド](Commands.md) - 便利なCFコマンド
