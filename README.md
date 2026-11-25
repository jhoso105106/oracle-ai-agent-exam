# Oracle Fusion AI Agent Studio 試験対策アプリ

Oracle Fusion AI Agent Studio Foundations Associate（1Z0-1145-1-JPN）向けの日本語模擬試験アプリです。

## 公開サイト

https://jhoso105106.github.io/oracle-ai-agent-exam/index.html

## にゃんこおみくじ ハンズオン

PowerPoint教材の内容に沿って、AIでアプリを作り Netlify Drop で公開する初心者向けガイドです。

https://jhoso105106.github.io/oracle-ai-agent-exam/hands-on.html

- 手順1〜10を「前へ」「次へ」で進行
- AIに渡すプロンプトのコピー機能
- スマートフォンにも対応
- 受講生アプリのギャラリー（投稿後、管理者が承認した作品のみ掲載）

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

## 受講生アプリギャラリー

`hands-on.html` のギャラリーは、投稿された作品をSupabaseに保存し、管理者が承認した作品だけを公開します。フォームでは作品名・Netlifyの公開URL・紹介文・任意のニックネームを受け付けます。URLのホスト名が `*.netlify.app` であることをブラウザーとデータベースの両方で確認します。これはドメイン形式の確認であり、サイトの内容や安全性を自動判定するものではありません。投稿情報は承認前もSupabaseに保存されるため、フォーム付近の説明と同意を確認してから利用してください。

既存の試験アプリ用Supabaseプロジェクトには [`supabase-gallery-setup.sql`](./supabase-gallery-setup.sql) だけを適用してください。これはギャラリー用テーブルとRLSポリシーのみを作成し、既存の試験進捗テーブルや回答データには触れません。新しいSupabaseプロジェクトを最初から設定する場合は、[`supabase-setup.sql`](./supabase-setup.sql) に両方の設定が含まれています。

すでにギャラリーを設定済みのプロジェクトでは、URL制限を追加するため [`supabase-gallery-netlify-validation.sql`](./supabase-gallery-netlify-validation.sql) もSQL Editorで実行してください。既存の投稿はそのまま残し、新しい投稿にNetlifyのURL制限を適用します。

Supabase SQL Editorで `select id, project_title, project_url, description, nickname from public.student_app_gallery where is_approved = false order by created_at;` を実行すると未承認投稿を確認できます。掲載する投稿だけ、確認したIDを指定して `update public.student_app_gallery set is_approved = true where id = <投稿ID>;` を実行してください。

匿名投稿は承認待ち状態でのみ可能です。一般ユーザーは承認済み作品のみ読め、投稿の更新・削除や承認状態の変更はできません。公開フォームは誰でも送信できるため、Netlifyのドメインであってもリンク先の内容を管理者が確認し、不適切な投稿を承認しないでください。`service_role` keyやデータベースパスワードは公開サイトに設定しないでください。

## ファイル

| ファイル | 内容 |
| --- | --- |
| `index.html` | GitHub Pagesで公開するアプリ本体 |
| `hands-on.html` | にゃんこおみくじを作って公開するハンズオン |
| `oracle_1z0_1145_1_practice_app.html` | アプリ本体のコピー |
| `supabase-setup.sql` | 試験進捗・作品ギャラリーのテーブルとRLSポリシー |
| `supabase-gallery-setup.sql` | 既存Supabaseプロジェクト向けのギャラリー設定 |
| `supabase-gallery-netlify-validation.sql` | 設定済みギャラリーへのNetlify URL制限追加 |
