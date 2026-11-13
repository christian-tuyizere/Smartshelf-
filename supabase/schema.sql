-- SmartShelf account-owned cloud storage.
-- Run this in Supabase Dashboard -> SQL Editor.
create table if not exists public.shop_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.shop_data enable row level security;

-- Each signed-in user can access only their own shop record.
drop policy if exists "Users can read their own SmartShelf data" on public.shop_data;
create policy "Users can read their own SmartShelf data"
  on public.shop_data for select
  to authenticated
  using (auth.uid() = user_id);

drop policy if exists "Users can insert their own SmartShelf data" on public.shop_data;
create policy "Users can insert their own SmartShelf data"
  on public.shop_data for insert
  to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own SmartShelf data" on public.shop_data;
create policy "Users can update their own SmartShelf data"
  on public.shop_data for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

grant select, insert, update on public.shop_data to authenticated;
