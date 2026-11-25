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
