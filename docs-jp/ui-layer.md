# UIレイヤー

このドキュメントでは、ローカルメールアプリケーションのUIレイヤーを説明します。

## 概要

UIレイヤーはSAP Fiori Elementsアプリケーションで、`app/browse/`フォルダにあります。SAPUI5フレームワークとFiori Elementsパターンを使用しています。

## Fioriアプリケーション構造

```
app/browse/
├── annotations.cds              # CDS UI注釈
├── webapp/
│   ├── Component.js             # UI5コンポーネント定義
│   ├── manifest.json            # UI5アプリケーションマニフェスト
│   ├── i18n/
│   │   └── i18n.properties      # 国際化ファイル
│   └── ext/
│       └── controller/
│           ├── ListReportExt.controller.js    # List Report拡張
│           └── ObjectPageExt.controller.js    # Object Page拡張
```

## UI5アプリケーションマニフェスト

`manifest.json`ファイルは、アプリケーションの主要な設定ファイルです：

### 主な設定

| セクション | 目的 |
|-----------|------|
| `sap.app` | アプリケーションメタデータ（ID、タイプ、タイトル） |
| `sap.ui5` | UI5設定（ルーティング、モデル、ライブラリ） |
| `sap.ui` | UIテクノロジー設定（テクノロジー、デバイスタイプ） |
| `sap.fiori` | Fiori固有の設定 |

### ルーティング設定

```json
"routing": {
    "config": {},
    "routes": [
        {
            "pattern": ":?query:",
            "name": "EmailListReport",
            "target": "EmailListReport"
        },
        {
            "pattern": "Email({key}):?query:",
            "name": "EmailObjectPage",
            "target": "EmailObjectPage"
        }
    ]
}
```

| ルート | パターン | 説明 |
|--------|---------|------|
| `EmailListReport` | `:?query:` | List Reportビュー（フィルタとテーブル） |
| `EmailObjectPage` | `Email({key})` | 選択されたメールのObject Page |

## CDS注釈によるUIレイアウト

`annotations.cds`ファイルは、UIレイアウトを定義します：

```cds
annotate CatalogService.Emails with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'メールアドレス',
            Value : emailAddress,
        },
        {
            $Type : 'UI.DataField',
            Label : 'メールタイプ',
            Value : emailType,
        },
        {
            $Type : 'UI.DataField',
            Label : '所有者',
            Value : owner,
        }
    ]
);
```

## コントローラ拡張

### ListReportExt.controller.js

List Reportビューのカスタムロジックを提供します：

```javascript
sap.ui.define([
    "sap/ui/core/mvc/ControllerExtension"
], function (ControllerExtension) {
    "use strict";
    return ControllerExtension.extend("emailapp2.ext.controller.ListReportExt", {
        // カスタムロジックをここに追加
    });
});
```

### ObjectPageExt.controller.js

Object Pageビューのカスタムロジックを提供します。

## ナビゲーションフロー

### デフォルトのFioriナビゲーション
通常、新しいレコードを作成した後：
1. **画面1**: List Report（フィルタテーブル）
2. **画面2**: Object Page（編集フォーム） - 新しいレコードを作成
3. **画面3**: 作成後、新しいレコードのObject Pageにナビゲート

### カスタムナビゲーション
このアプリケーションはナビゲーションを変更します：
1. **画面1**: List Report
2. **画面2**: Object Page - 新しいメールを作成
3. **画面1に戻る**: 作成後、List Reportにリダイレクト（Object Pageをスキップ）

このカスタム動作は、`ObjectPageExt.controller.js`で拡張ポイントを使用して実装されます。

## 国際化（i18n）

`i18n.properties`ファイルには、アプリケーションで使用される翻訳されたテキストが含まれています：

```properties
# このファイルのプロパティには、SAPUI5アプリケーションで使用されるテキストがあります

appTitle=メールを参照
appDescription=Fiori Elementsアプリケーションでメールを参照・管理

# フィールドラベル
emailAddress=メールアドレス
emailType=メールタイプ
owner=所有者
```

## 関連ドキュメント

- [サービスレイヤー](service-layer.md) - バックエンドODataサービス
- [設定ファイル](configuration-files.md) - UI設定
- [デプロイメント](deployment.md) - アプリケーションのデプロイ方法
