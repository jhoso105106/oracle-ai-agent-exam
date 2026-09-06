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
