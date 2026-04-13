# コマンド

## 開発コマンド

### 依存関係のインストール
```bash
npm install
```

### ローカル開発サーバーの起動
```bash
npm start
# または
cds watch
```
サーバーは http://localhost:4004 で実行されます

### CAPツールキットのインストール
```bash
npm add -g @sap/cds-dk
```

## データベースコマンド

### SQLiteデータベースへのデプロイ
```bash
cds deploy --to sqlite
```

### HANAへのデプロイ
```bash
cds deploy --to hana
```

## ビルドコマンド

### MTAビルド
```bash
mbt build
```

## デプロイメントコマンド

### Cloud Foundryへのログイン
```bash
cf login -a https://api.cf.us10.hana.ondemand.com
```

### MTARアーカイブのデプロイ
```bash
cf deploy mta_archives/*.mtar
```

### 個別モジュールへのデプロイ
```bash
# データベースコンテンツのデプロイ
cf deploy mta_archives/*.mtar -m emailapp2-db-deployer

# サービスモジュールのデプロイ
cf deploy mta_archives/*.mtar -m emailapp2-srv

# アプリケーションローターのデプロイ
cf deploy mta_archives/*.mtar -m emailapp2-approuter
```

## SAP HANA Cloudコマンド

### HANA Cloudインスタンスの停止
```bash
cf stop-emailapp2-hana
```

### HANA Cloudインスタンスの開始
```bash
cf start-emailapp2-hana
```

## トラブルシューティングコマンド

### アプリケーションログの表示
```bash
cf logs emailapp2-srv --recent
```

### アプリケーションSSH
```bash
cf ssh emailapp2-srv
```

### 環境変数の確認
```bash
cf env emailapp2-srv
```

### サービスインスタンスの確認
```bash
cf services
```
