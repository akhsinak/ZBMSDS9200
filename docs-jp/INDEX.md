# 概要

このドキュメントは、SAP CAPとFiori Elementsで構築されたローカルメールアプリケーションの包括的なガイドを提供します。

## 目次
* [はじめに](README.md)
* [プロジェクト構造](project-structure.md)

## アプリケーション層

* [データベースレイヤー](database-layer.md)
  * [エンティティ定義](database-layer.md#エンティティ定義)
  * [Managedアスペクト](database-layer.md#managedアスペクト)

* [サービスレイヤー](service-layer.md)
  * [サービス定義](service-layer.md#サービス定義)
  * [ユーザーフィルタリング](service-layer.md#ユーザーフィルタリング)

* [UIレイヤー](ui-layer.md)
  * [Fioriアプリケーション構造](ui-layer.md#fioriアプリケーション構造)
  * [Manifest設定](ui-layer.md#ui5アプリケーションマニフェスト)
  * [コントローラ拡張](ui-layer.md#コントローラ拡張)
  * [ナビゲーションフロー](ui-layer.md#ナビゲーションフロー)

## 設定とデプロイメント

* [設定ファイル](configuration-files.md)
  * [package.json](configuration-files.md#package-json)
  * [mta.yaml](configuration-files.md#mta-yaml)
  * [manifest.yml](configuration-files.md#manifest-yml)
  * [xs-security.json](configuration-files.md#xs-security-json)

* [セキュリティと認可](security.md)
  * [認証](security.md#認証)
  * [認可](security.md#認可)
  * [XSUAA設定](security.md#xsuaa設定)

* [デプロイメント](deployment.md)
  * [ビルドプロセス](deployment.md#ビルドプロセス)
  * [CFデプロイメント](deployment.md#cfデプロイメント)
  * [アプリケーションローター](deployment.md#アプリケーションローター)

## 付録

* [ファイルリファレンス](file-reference.md)
* [用語集](glossary.md)


## コマンド

便利なコマンドの一覧は[[コマンド]]を参照してください
