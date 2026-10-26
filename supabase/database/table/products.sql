-- Supabase/PostgreSQL product catalog schema.
-- Schema definition only; this file does not apply changes to a database.

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  description text,
  price numeric(12, 2) not null check (price >= 0),
  stock integer not null default 0 check (stock >= 0),
  image_url text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists products_is_active_idx
  on public.products (is_active);

create index if not exists products_created_at_idx
  on public.products (created_at desc);
