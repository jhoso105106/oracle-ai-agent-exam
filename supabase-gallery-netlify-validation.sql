do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.student_app_gallery'::regclass
      and conname = 'student_app_gallery_netlify_url_check'
  ) then
    alter table public.student_app_gallery
      add constraint student_app_gallery_netlify_url_check
      check (
        project_url ~* '^https://[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\.netlify\.app(/[^[:space:]]*)?$'
      ) not valid;
  end if;
end;
$$;
