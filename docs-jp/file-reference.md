# ファイルリファレンス

このドキュメントでは、ローカルメールアプリケーション内の主要なファイルとその目的を一覧表示します。

## ルートプロジェクトファイル

| ファイル | 説明 |
|---------|------|
| `package.json` | Node.jsプロジェクト設定と依存関係 |
| `mta.yaml` | MTA（マルチターゲットアプリケーション）記述子 |
| `xs-security.json` | XSUAAセキュリティ設定 |
| `manifest.yml` | Cloud Foundryマニフェスト（オプション） |
| `.gitignore` | Git無視パターン |

## データベースレイヤー（`db/`）

| ファイル | 説明 |
|---------|------|
| `schema.cds` | CDSエンティティ定義（Emailsテーブル） |

## サービスレイヤー（`srv/`）

| ファイル | 説明 |
|---------|------|
| `cat-service.cds` | OData V4サービス定義 |
| `cat-service.js` | サービス実装とカスタムロジック |

## UIレイヤー（`app/browse/`）

| ファイル | 説明 |
|---------|------|
| `annotations.cds` | Fiori UIレイアウトのCDS注釈 |
| `webapp/Component.js` | UI5コンポーネント定義 |
| `webapp/manifest.json` | UI5アプリケーションマニフェスト |
| `webapp/i18n/i18n.properties` | 国際化（翻訳）ファイル |
| `webapp/ext/controller/ListReportExt.controller.js` | List Reportコントローラ拡張 |
| `webapp/ext/controller/ObjectPageExt.controller.js` | Object Pageコントローラ拡張 |

## ドキュメント（`docs/`）

| ファイル | 説明 |
|---------|------|
| `README.md` | メインドキュメント（イントロダクション） |
| `INDEX.md` | ドキュメントの目次 |
| `project-structure.md` | プロジェクト構造の説明 |
| `database-layer.md` | データベースレイヤードキュメント |
| `service-layer.md` | サービスレイヤードキュメント |
| `ui-layer.md` | UIレイヤードキュメント |
| `configuration-files.md` | 設定ファイルの説明 |
| `security.md` | セキュリティと認可 |
| `deployment.md` | デプロイメントガイド |
| `file-reference.md` | このファイル - ファイル一覧 |
| `glossary.md` | 用語集 |
| `Commands.md` | 便利なコマンド |

## 生成されたファイル（`gen/`）

| ファイル/フォルダ | 説明 |
|------------------|------|
| `srv/` | コンパイルされたサービスコード |
| `db/` | データベースアーティファクト |
| `mta_archives/` | ビルドされたMTAアーカイブ（デプロイメント用） |

## 設定フォルダ

| フォルダ | 説明 |
|---------|------|
| `.vscode/` | VS Code設定 |
| `.cds-gen/` | CDSジェネレーター出力 |
| `node_modules/` | npm依存関係 |

## 関連ドキュメント

- [プロジェクト構造](project-structure.md) - 詳細な構造の説明
- [設定ファイル](configuration-files.md) - 設定の詳細
