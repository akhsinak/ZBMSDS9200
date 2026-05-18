# プロジェクト構造

このドキュメントでは、ローカルメールアプリケーションのフォルダ構造と各コンポーネントの目的を説明します。

## 概要

```
ZBMSDS9200/
├── app/                          # UIレイヤー
│   └── browse/                   # Fiori Elementsアプリケーション
│       ├── webapp/              # UI5アプリケーションコード
│       │   ├── Component.js     # UI5コンポーネント定義
│       │   ├── manifest.json    # UI5アプリケーションマニフェスト
│       │   ├── i18n/            # 国際化ファイル
│       │   └── ext/             # コントローラ拡張
│       └── annotations.cds      # UI注釈
│
├── db/                          # データベースレイヤー
│   └── schema.cds               # CDSエンティティ定義
│
├── srv/                         # サービスレイヤー
│   └── cat-service.cds          # ODataサービス定義
│
├── docs/                        # ドキュメント
│   └── *.md                     # マークダウンドキュメントファイル
│
├── mta.yaml                     # MTA（Multi-Target Application）設定
├── package.json                 # Node.js依存関係
├── xs-security.json             # XSUAAセキュリティ設定
└── manifest.yml                 # Cloud Foundryマニフェスト
```

## 詳細な構造

### アプリケーションレイヤー（`app/browse/`）

Fiori Elements UIアプリケーションが含まれています：

| ファイル                                            | 目的                                                            |
| --------------------------------------------------- | --------------------------------------------------------------- |
| `webapp/Component.js`                               | UI5コンポーネントの初期化と設定                                 |
| `webapp/manifest.json`                              | アプリケーションマニフェスト - ルーティング、モデル、設定を定義 |
| `webapp/i18n/`                                      | 翻訳ファイル（i18n.properties）                                 |
| `webapp/ext/controller/ListReportExt.controller.js` | List Reportコントローラ拡張                                     |
| `webapp/ext/controller/ObjectPageExt.controller.js` | Object Pageコントローラ拡張                                     |
| `annotations.cds`                                   | CDS注釈によるUIレイアウト定義                                   |

### データベースレイヤー（`db/`）

データモデルとスキーマ定義：

| ファイル     | 目的                                  |
| ------------ | ------------------------------------- |
| `schema.cds` | CDSエンティティ定義（Emailsテーブル） |

### サービスレイヤー（`srv/`）

ビジネスロジックとODataサービス：

| ファイル          | 目的                                           |
| ----------------- | ---------------------------------------------- |
| `cat-service.cds` | OData V4サービス定義とエンティティ公開         |
| `cat-service.js`  | サービス実装とカスタムロジック（存在する場合） |

## 設定ファイル

### mta.yaml

MTAビルドツール用のマルチターゲットアプリケーション記述子。アプリケーションモジュールと依存関係を定義します。

### package.json

Node.jsプロジェクト設定。CAP依存関係とスクリプトが含まれています。

### xs-security.json

SAP XSUAA（Extended Services for User Account and Authentication）設定。アプリケーションセキュリティロールとスコープを定義します。

### manifest.yml

Cloud Foundryデプロイメント用のオプションのマニフェストファイル。

## ナビゲーション

- [データベースレイヤー](database-layer.md)
- [サービスレイヤー](service-layer.md)
- [UIレイヤー](ui-layer.md)
