# ローカルメールアプリケーション ドキュメント

**ローカルメールアプリケーション**へようこそ - SAP Cloud Application Programming Model（CAP）ベースのアプリケーションで、Fiori Elementsフロントエンドを使用しています。

## 概要

このアプリケーションでは、ユーザーは以下のことができます：
- メールアドレスの作成と管理
- 自分が作成したメールのみを表示（ユーザースコープデータ）
- List ReportとObject Pageパターンを備えた最新のSAP Fioriインターフェースの使用

## アーキテクチャ

このアプリケーションは、**CAP（Cloud Application Programming Model）**アーキテクチャに従っており、3つの主要なレイヤーがあります：

1. **データベースレイヤー**（`db/`）- ドメインモデルとデータ永続化
2. **サービスレイヤー**（`srv/`）- ビジネスロジックとODataサービス
3. **UIレイヤー**（`app/`）- Fiori Elementsフロントエンドアプリケーション

## クイックリンク

- [プロジェクト構造](project-structure.md)
- [データベースレイヤー](database-layer.md)
- [サービスレイヤー](service-layer.md)
- [UIレイヤー](ui-layer.md)
- [設定ファイル](configuration-files.md)
- [セキュリティと認可](security.md)
- [デプロイメント](deployment.md)

## 技術スタック

| コンポーネント | 技術 |
|-----------|-----------|
| バックエンドフレームワーク | SAP CAP（Cloud Application Programming Model）|
| データベース | SAP HANA Cloud |
| ODataバージョン | OData V4 |
| UIフレームワーク | SAPUI5 / Fiori Elements |
| UI5バージョン | 1.136.0 |
| 認証 | SAP XSUAA |

## 始め方

### 前提条件
- Node.js 20.x
- SAP BTPアカウント（デプロイメント用）
- SAP HANA Cloudインスタンス

### ローカル開発
```bash
# 依存関係のインストール
npm install

# CAPサーバーのローカル起動
npm start
# サーバーは http://localhost:4004 で実行されます
```

### アプリケーションへのアクセス
- **ODataサービス**: `http://localhost:4004/odata/v4/email/`
- **Fioriアプリ**: `http://localhost:4004/app/browse/webapp/index.html`

## 主な機能

### ユーザースコープデータアクセス
このアプリケーションでは、各行レベルのセキュリティを実装しており、各ユーザーは自分が作成したメールのみを表示・管理できます。これは、サービスレイヤーでCAPの`managed`アスペクトを使用して実装されています。

### ドラフト対応CRUD
ODataサービスはドラフト機能をサポートしており、ユーザーは以下ができます：
- 新しいメールドラフトの作成
- 既存のメールの編集
- 変更の保存または破棄

### カスタムナビゲーションフロー
コントローラ拡張により、デフォルトのFioriナビゲーション動作が変更されます - *画面2*で新しいメールを作成した後、ユーザーはオブジェクトページではなくリストビュー（*画面1*）にリダイレクトされます。
