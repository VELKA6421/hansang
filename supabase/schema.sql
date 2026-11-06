-- Supabase SQL Editor에서 한 번 실행합니다.
create table public.posts (
  id uuid primary key default gen_random_uuid(),
  food_id text not null check (food_id in ('bibimbap','jjigae','bulgogi','kimchi','noodles','tteokbokki','pajeon','gimbap','samgyetang','japchae','songpyeon','bingsu','tea','chicken','friedrice','tacos')),
  user_id uuid not null references auth.users(id) on delete cascade,
  author text not null check (char_length(trim(author)) between 1 and 30),
  title text not null check (char_length(trim(title)) between 1 and 100),
  body text not null check (char_length(trim(body)) between 1 and 10000),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index posts_food_created_idx on public.posts(food_id, created_at desc);
alter table public.posts enable row level security;
grant select on public.posts to anon, authenticated;
grant insert, update, delete on public.posts to authenticated;
create policy "Anyone can read posts" on public.posts for select using (true);
create policy "Authors can insert their posts" on public.posts for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "Authors can update their posts" on public.posts for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "Authors can delete their posts" on public.posts for delete to authenticated using ((select auth.uid()) = user_id);
-- 생성 시각/소유자/음식 페이지를 수정 요청으로 바꾸지 못하게 합니다.
create function public.protect_post_metadata() returns trigger language plpgsql set search_path = '' as $$
begin
  if TG_OP = 'UPDATE' then
    NEW.id := OLD.id;
    NEW.user_id := OLD.user_id;
    NEW.food_id := OLD.food_id;
    NEW.created_at := OLD.created_at;
  else
    NEW.created_at := now();
  end if;
  NEW.updated_at := now();
  return NEW;
end;
$$;
create trigger protect_post_metadata before insert or update on public.posts for each row execute function public.protect_post_metadata();
