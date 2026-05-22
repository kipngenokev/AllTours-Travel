-- =====================================================================
-- All-Tours — Supabase schema
-- Run this in the Supabase SQL Editor (Dashboard → SQL Editor → New query)
-- =====================================================================

-- ---------- Extensions ----------
create extension if not exists "uuid-ossp";

-- ---------- Enums ----------
do $$ begin
  create type continent_t as enum (
    'Africa', 'Asia', 'Europe', 'North America',
    'South America', 'Oceania', 'Antarctica'
  );
exception when duplicate_object then null; end $$;

do $$ begin
  create type media_type_t as enum ('photo', 'video');
exception when duplicate_object then null; end $$;

-- =====================================================================
-- profiles : 1-1 with auth.users, holds tourist display info
-- =====================================================================
create table if not exists public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  full_name   text,
  avatar_url  text,
  home_country text,
  created_at  timestamptz not null default now()
);

alter table public.profiles enable row level security;

drop policy if exists "profiles are viewable by owner" on public.profiles;
create policy "profiles are viewable by owner"
  on public.profiles for select using (auth.uid() = id);

drop policy if exists "users can insert own profile" on public.profiles;
create policy "users can insert own profile"
  on public.profiles for insert with check (auth.uid() = id);

drop policy if exists "users can update own profile" on public.profiles;
create policy "users can update own profile"
  on public.profiles for update using (auth.uid() = id);

-- Auto-create a profile row when a new auth user signs up
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, new.raw_user_meta_data->>'full_name')
  on conflict (id) do nothing;
  return new;
end; $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- =====================================================================
-- places : the core catalogue of tourable destinations
-- best_months : integers 1..12 when the place is at its best
--               (drives the "best to visit this season" suggestions)
-- =====================================================================
create table if not exists public.places (
  id            uuid primary key default uuid_generate_v4(),
  name          text not null,
  country       text not null,
  continent     continent_t not null,
  summary       text,                       -- short tagline
  description   text,                       -- full description
  guidelines    text,                       -- travel tips / guidelines
  best_months   smallint[] not null default '{}',
  hemisphere    text not null default 'N',  -- 'N' or 'S' (for season mapping)
  cover_image_url text,
  video_url     text,
  latitude      double precision,
  longitude     double precision,
  tags          text[] not null default '{}',
  rating        numeric(2,1) default 4.5,
  created_at    timestamptz not null default now()
);

create index if not exists places_continent_idx on public.places (continent);
create index if not exists places_best_months_idx on public.places using gin (best_months);

alter table public.places enable row level security;

drop policy if exists "places are public" on public.places;
create policy "places are public"
  on public.places for select using (true);

-- =====================================================================
-- place_media : multiple photos / videos per place
-- =====================================================================
create table if not exists public.place_media (
  id        uuid primary key default uuid_generate_v4(),
  place_id  uuid not null references public.places(id) on delete cascade,
  type      media_type_t not null,
  url       text not null,
  caption   text,
  position  int not null default 0
);

create index if not exists place_media_place_idx on public.place_media (place_id);

alter table public.place_media enable row level security;

drop policy if exists "media is public" on public.place_media;
create policy "media is public"
  on public.place_media for select using (true);

-- =====================================================================
-- favorites : tourist bookmarks
-- =====================================================================
create table if not exists public.favorites (
  user_id    uuid not null references auth.users(id) on delete cascade,
  place_id   uuid not null references public.places(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, place_id)
);

alter table public.favorites enable row level security;

drop policy if exists "users manage own favorites" on public.favorites;
create policy "users manage own favorites"
  on public.favorites for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- =====================================================================
-- consultation_requests : trip-planning / consultancy service requests
-- One row per plan a traveller requests, tied to a pricing tier.
-- Tier id/name/price are snapshotted so historical rows stay accurate
-- even if the in-app pricing later changes.
-- =====================================================================
do $$ begin
  create type consultation_status_t as enum (
    'submitted', 'reviewing', 'delivered', 'cancelled'
  );
exception when duplicate_object then null; end $$;

create table if not exists public.consultation_requests (
  id               uuid primary key default uuid_generate_v4(),
  user_id          uuid not null references auth.users(id) on delete cascade,
  tier_id          text not null,
  tier_name        text not null,
  price_label      text,
  full_name        text not null,
  email            text not null,
  destinations     text not null,
  start_date       date,
  trip_length_days int,
  travelers        int not null default 1,
  budget           text,
  interests        text[] not null default '{}',
  notes            text,
  wants_call       boolean not null default false,
  status           consultation_status_t not null default 'submitted',
  created_at       timestamptz not null default now()
);

create index if not exists consultation_requests_user_idx
  on public.consultation_requests (user_id);

alter table public.consultation_requests enable row level security;

drop policy if exists "users manage own requests"
  on public.consultation_requests;
create policy "users manage own requests"
  on public.consultation_requests for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- =====================================================================
-- RPC: places_in_season(month int)
-- Returns places whose best_months contains the given month.
-- =====================================================================
create or replace function public.places_in_season(p_month int)
returns setof public.places language sql stable as $$
  select * from public.places
  where p_month = any(best_months)
  order by rating desc nulls last, name;
$$;
