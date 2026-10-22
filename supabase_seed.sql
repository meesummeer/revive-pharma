-- ═══════════════════════════════════════════════════
-- REVIVE PHARMA SYSTEM — Supabase Full Seed
-- Run once in: Supabase → SQL Editor → New Query
-- ═══════════════════════════════════════════════════

-- 1. DROP & RECREATE TABLES (clean slate)
drop table if exists products cascade;
drop table if exists bills cascade;
drop table if exists pharmas cascade;

-- 2. PHARMAS TABLE
create table pharmas (
  id      text primary key,
  name    text not null,
  alias   text default '',
  type    text not null check (type in ('profit','business')),
  pct     numeric not null default 30,
  contact text default '',
  notes   text default '',
  created_at timestamptz default now()
);

-- 3. BILLS TABLE
create table bills (
  id          text primary key,
  pharma_id   text references pharmas(id),
  bill_no     text,
  date        date,
  amount      numeric not null,
  description text default '',
  status      text not null default 'unpaid' check (status in ('paid','unpaid')),
  created_at  timestamptz default now()
);

-- 4. PRODUCTS TABLE
create table products (
  id          text primary key,
  pharma_id   text references pharmas(id),
  name        text not null,
  qty         integer default 0,
  total       integer default 0,
  low_at      integer default 2,
  date_added  date default current_date,
  created_at  timestamptz default now()
);

-- ═══ SEED DATA ═══════════════════════════════════════

-- PHARMAS
insert into pharmas (id, name, alias, type, pct) values
  ('arcure',       'Arcure Pharma', 'Mars Enterprises',  'profit',   30),
  ('truecare',     'TrueCare',      'Rapid Pharma',      'business', 30),
  ('helix',        'Helix',         'Ascent Enterprises','business', 30),
  ('auraceutical', 'Auraceutical',  '',                  'profit',   30),
  ('dermcare',     'Dermcare',      '',                  'profit',   30),
  ('gns',          'GNS Pharma',    '',                  'profit',   40);

-- BILLS
insert into bills (id, pharma_id, bill_no, date, amount, description, status) values
  ('b1', 'arcure',   '01',     '2026-07-07', 16250,  'ARCU GLEAM Facewash ×5, ARCUDERM CS Serum ×5',                                                                                                                                                    'unpaid'),
  ('b2', 'arcure',   '02',     '2026-08-12', 32500,  'ARCU GLEAM Facewash ×10, ARCUDERM CS Serum ×10',                                                                                                                                                   'unpaid'),
  ('b3', 'truecare', '565114', '2026-07-09', 115262, 'Elysion Caps, Glowris Cream, Provillus Hair Spray, Provillus Shampoo, Provillus-T Tab',                                                                                                            'paid'),
  ('b4', 'truecare', '577462', '2026-09-03', 24434,  'Glowris Cream ×5, Nutiplex Tab ×5, Provillus-T Tab ×5',                                                                                                                                            'paid'),
  ('b5', 'truecare', '567340', '2026-07-20', 20551,  'Acelga Face Wash ×3, Provillus Hair Spray ×3, Provillus Shampoo ×3, Provillus-T Tab ×3, Tinzo UK Ointment ×3',                                                                                    'paid'),
  ('b6', 'truecare', '577615', '2026-09-04', 28257,  'Dermeola Lotion ×5, Glowris Cream ×5, Nutiplex Tab ×5, Provillus-T Tab ×5',                                                                                                                        'paid'),
  ('b7', 'truecare', '587810', '2026-10-16', 19978,  'Acelga Face Wash ×5, Glowris Cream ×5, Provillus Shampoo ×5',                                                                                                                                      'unpaid'),
  ('b8', 'helix',    '7549',   '2026-07-09', 134452, 'Clariderm Anti Acne Face Wash ×10, Clariderm Anti Acne Serum ×5, Eyeconic Serum ×5, Hydra FX Moisturizing Serum ×5, Solero SC SPF ×5, Solero Tinted SPF ×5, Tressfix Hair Serum ×10, Tressfix Shampoo ×10, Tressfix Tablet ×10, Wynn Brightening Cream ×5, Wynn Brightening Serum ×5', 'unpaid'),
  ('b9', 'gns',      '01',     '2026-10-22', 56900,  'Acnoaie Serum ×10, Acnoaie Face Wash ×10, Retegin Body Sol ×5',                                                                                                                                    'unpaid');

-- PRODUCTS
insert into products (id, pharma_id, name, qty, total, low_at, date_added) values
  ('p1',  'arcure',   'ARCU GLEAM Facewash',           6,  15, 2, '2026-08-12'),
  ('p2',  'arcure',   'ARCUDERM CS Serum',             6,  15, 2, '2026-08-12'),
  ('p3',  'truecare', 'Acelga Face Wash',              5,   5, 2, '2026-09-04'),
  ('p4',  'truecare', 'Provillus Shampoo',             5,   5, 2, '2026-09-04'),
  ('p5',  'truecare', 'Glowris Cream',                 5,   5, 2, '2026-09-04'),
  ('p6',  'helix',    'Solero Tinted SPF 60',          5,   5, 2, '2026-07-09'),
  ('p7',  'helix',    'Tressfix Tablet 30s',          10,  10, 3, '2026-07-09'),
  ('p8',  'helix',    'Tressfix Hair Serum 60ml',     10,  10, 3, '2026-07-09'),
  ('p9',  'helix',    'Tressfix Shampoo 120ml',        5,  10, 3, '2026-07-09'),
  ('p10', 'helix',    'Clariderm Anti Acne Face Wash', 8,  10, 3, '2026-07-09'),
  ('p11', 'helix',    'Clariderm Anti Acne Serum',     5,   5, 2, '2026-07-09'),
  ('p12', 'helix',    'Wynn Brightening Cream 30gm',   3,   5, 2, '2026-07-09'),
  ('p13', 'helix',    'Wynn Brightening Serum 20ml',   5,   5, 2, '2026-07-09'),
  ('p14', 'helix',    'Eyeconic Serum 20ml',           0,   5, 1, '2026-07-09'),
  ('p15', 'helix',    'Hydra FX Moisturizing Serum',   0,   5, 1, '2026-07-09'),
  ('p16', 'helix',    'Solero SC SPF40/P++ 30gm',      0,   5, 1, '2026-07-09'),
  ('p17', 'gns',      'Acnoaie Serum',                10,  10, 3, '2026-10-22'),
  ('p18', 'gns',      'Acnoaie Face Wash',            10,  10, 3, '2026-10-22'),
  ('p19', 'gns',      'Retegin Body Sol',              5,   5, 2, '2026-10-22');

-- Enable RLS + allow anon reads/writes (so the app can talk to Supabase)
alter table pharmas enable row level security;
alter table bills enable row level security;
alter table products enable row level security;

create policy "anon_all_pharmas"  on pharmas  for all to anon using (true) with check (true);
create policy "anon_all_bills"    on bills     for all to anon using (true) with check (true);
create policy "anon_all_products" on products  for all to anon using (true) with check (true);
