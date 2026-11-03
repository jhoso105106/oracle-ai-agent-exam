# Oracle Fusion AI Agent Studio 試験対策アプリ

Oracle Fusion AI Agent Studio Foundations Associate（1Z0-1145-1-JPN）向けの日本語模擬試験アプリです。

## 公開サイト

https://jhoso105106.github.io/oracle-ai-agent-exam/index.html

## にゃんこおみくじ ハンズオン

PowerPoint教材の内容に沿って、AIでアプリを作り Netlify Drop で公開する初心者向けガイドです。

https://jhoso105106.github.io/oracle-ai-agent-exam/hands-on.html

- 手順1〜8を「前へ」「次へ」で進行
- AIに渡すプロンプトのコピー機能
- スマートフォンにも対応

## 機能

- 50問の模擬試験（単一選択・複数選択）
- 60分タイマー
- 回答後の正解表示と解説
- 間違えた問題だけを解く復習モード
- セクション別フィルター
- 日本語音声読み上げ（対応ブラウザのみ）
- Supabaseへの回答進捗保存

## ローカルで実行

ビルドは不要です。`index.html` をブラウザで開くか、次のコマンドで静的サーバーを起動します。

```powershell
python -m http.server 8000
```

その後、http://localhost:8000/index.html を開きます。

## Supabase設定

回答保存にはSupabaseの匿名ログインと `quiz_progress` テーブルを使用します。

1. SupabaseプロジェクトをFreeプランで作成する
2. Authentication → Sign In / Providers → Allow anonymous sign-ins を有効にする
3. SQL Editorで [`supabase-setup.sql`](./supabase-setup.sql) を実行する
4. `index.html` のSupabase URLとPublishable keyを設定する

`service_role` keyやデータベースパスワードは、ブラウザやGitHubへ保存しないでください。

## ファイル

| ファイル | 内容 |
| --- | --- |
| `index.html` | GitHub Pagesで公開するアプリ本体 |
| `hands-on.html` | にゃんこおみくじを作って公開するハンズオン |
| `oracle_1z0_1145_1_practice_app.html` | アプリ本体のコピー |
| `supabase-setup.sql` | SupabaseのテーブルとRLSポリシー |
