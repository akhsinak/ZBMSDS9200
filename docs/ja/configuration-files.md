# 設定ファイル

このドキュメントでは、ローカルメールアプリケーションで使用される主要な設定ファイルについて説明します。

## 概要

このアプリケーションは、さまざまな目的のために複数の設定ファイルを使用します。

## package.json

`package.json`は、Node.jsプロジェクト設定と依存関係を定義します。

### 主なフィールド

| フィールド        | 説明                                        |
| ----------------- | ------------------------------------------- |
| `name`            | パッケージ名 - `zbmsds9200`                 |
| `version`         | セマンティックバージョン - `1.0.2`          |
| `dependencies`    | 本番環境依存関係（CAP、HANA、セキュリティ） |
| `devDependencies` | 開発環境依存関係（SQLite、CDS-DK）          |
| `scripts`         | npmスクリプト（`start`コマンドなど）        |
| `engines`         | 必要なNode.jsバージョン（`20.x`）           |
| `cds`             | CAP固有の設定                               |

### CDS設定セクション

```json
"cds": {
  "requires": {
    "db": {
      "kind": "hana"
    },
    "destinations": true,
    "html5-repo": true,
    "workzone": true
  }
}
```

| プロパティ     | 説明                                            |
| -------------- | ----------------------------------------------- |
| `db.kind`      | データベースタイプ - `hana`または`sqlite`       |
| `destinations` | SAP BTP宛先サービスの有効化                     |
| `html5-repo`   | HTML5アプリケーションレポジトリサービスの有効化 |
| `workzone`     | SAP Build WorkZoneサービスの有効化              |

## mta.yaml

`mta.yaml`は、SAP Business Technology Platform（BTP）用のマルチターゲットアプリケーション（MTA）記述子です。

### モジュール

| モジュール                      | タイプ                        | 説明                                   |
| ------------------------------- | ----------------------------- | -------------------------------------- |
| `emailapp2-db-deployer`         | `hdb`                         | HANAデータベースデプロイヤー           |
| `emailapp2-srv`                 | `nodejs`                      | CAPサービスモジュール                  |
| `emailapp2`                     | `com.sap.application.content` | アプリケーションデプロイメントコンテナ |
| `emailapp2-approuter`           | `approuter.nodejs`            | SAPアプリケーションローター            |
| `emailapp2-destination-content` | `com.sap.application.content` | 宛先設定                               |

### リソース

| リソース                        | サービスタイプ    | 説明                            |
| ------------------------------- | ----------------- | ------------------------------- |
| `emailapp2-hana`                | `hana`            | SAP HANA Cloudインスタンス      |
| `emailapp2-destination-service` | `destination`     | SAP BTP宛先サービス             |
| `emailapp2-html5-repo-runtime`  | `html5-apps-repo` | HTML5アプリケーションレポジトリ |
| `emailapp2-uaa`                 | `xsuaa`           | SAP XSUAAサービス               |

## manifest.yml

`manifest.yml`は、オプションのCloud Foundryマニフェストファイルです。

```yaml
---
applications:
  - name: emailapp2-srv
    path: gen/srv
    memory: 256M
    services:
      - emailapp2-hana
      - emailapp2-uaa
```

| プロパティ | 説明                                   |
| ---------- | -------------------------------------- |
| `name`     | Cloud Foundryアプリケーション名        |
| `path`     | アーティファクトへのパス               |
| `memory`   | アプリケーションに割り当てられたメモリ |
| `services` | バインドされたサービスインスタンス     |

## xs-security.json

`xs-security.json`は、SAP XSUAA（Extended Services for User Account and Authentication）のセキュリティ設定を定義します。

### 主な要素

| 要素               | 説明                                                |
| ------------------ | --------------------------------------------------- |
| `xsappname`        | XSUAAアプリケーション名                             |
| `tenant-mode`      | マルチテナンシーモード（`dedicated`または`shared`） |
| `scopes`           | アプリケーション固有の認可スコープ                  |
| `role-templates`   | アプリケーションロール定義                          |
| `role-collections` | ロールコレクションと割り当て                        |

### セキュリティロール

```json
{
  "role-templates": [
    {
      "name": "EmailViewer",
      "description": "メールの表示",
      "scope-references": ["uaa.user", "$XSAPPNAME.Display"]
    }
  ]
}
```

## 関連ドキュメント

- [セキュリティと認可](security.md) - XSUAAと認可の詳細
- [デプロイメント](deployment.md) - これらのファイルを使用したデプロイメント
- [プロジェクト構造](project-structure.md) - 全ファイルの概要
