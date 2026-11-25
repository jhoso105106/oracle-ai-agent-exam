-- Run this once in Supabase SQL Editor.
create table if not exists public.quiz_progress (
  user_id uuid not null references auth.users(id) on delete cascade,
  question_id integer not null check (question_id between 1 and 50),
  selected_indexes integer[] not null default '{}',
  is_wrong boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (user_id, question_id)
);

alter table public.quiz_progress enable row level security;

drop policy if exists "Users can read own quiz progress" on public.quiz_progress;
create policy "Users can read own quiz progress"
  on public.quiz_progress for select
  to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Users can insert own quiz progress" on public.quiz_progress;
create policy "Users can insert own quiz progress"
  on public.quiz_progress for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users can update own quiz progress" on public.quiz_progress;
create policy "Users can update own quiz progress"
  on public.quiz_progress for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create table if not exists public.student_app_gallery (
  id bigint generated always as identity primary key,
  project_title text not null check (char_length(btrim(project_title)) between 1 and 80),
  project_url text not null check (
    char_length(project_url) <= 2048
    and project_url ~* '^https://[^[:space:]]+$'
    and project_url !~* '^https://[^/?#]*@'
  ),
  constraint student_app_gallery_netlify_url_check
    check (project_url ~* '^https://[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\.netlify\.app(/[^[:space:]]*)?$'),
  description text not null check (char_length(btrim(description)) between 1 and 280),
  nickname text check (nickname is null or char_length(btrim(nickname)) <= 30),
  is_approved boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.student_app_gallery enable row level security;

revoke all on public.student_app_gallery from public, anon, authenticated;
grant select on public.student_app_gallery to anon, authenticated;
grant insert (project_title, project_url, description, nickname)
  on public.student_app_gallery to anon, authenticated;

drop policy if exists "Anyone can read approved gallery entries" on public.student_app_gallery;
create policy "Anyone can read approved gallery entries"
  on public.student_app_gallery for select
  to anon, authenticated
  using (is_approved = true);

drop policy if exists "Anyone can submit unapproved gallery entries" on public.student_app_gallery;
create policy "Anyone can submit unapproved gallery entries"
  on public.student_app_gallery for insert
  to anon, authenticated
  with check (is_approved = false);
