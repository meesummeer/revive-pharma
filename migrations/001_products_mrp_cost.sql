-- Add per-product pricing to products.
-- Safe to re-run: the DB Migrate workflow runs every migration on each push.

alter table products add column if not exists mrp  numeric default 0;
alter table products add column if not exists cost numeric default 0;

-- Backfill prices that previously lived only in getDefaultData().
-- Only fills rows that are still unpriced, so later edits in the app are never overwritten.
update products as p set mrp = v.mrp, cost = v.cost
from (values
  ('p1',  2150, 1830),
  ('p2',  2550, 2170),
  ('p3',   950,  855),
  ('p4',  1550, 1395),
  ('p5',  2150, 1935),
  ('p6',  1020, 1024),
  ('p7',     0,  807),
  ('p8',     0, 2305),
  ('p9',     0,  807),
  ('p10',    0,  756),
  ('p11',    0, 1700),
  ('p12',    0, 1530),
  ('p13',    0, 1700),
  ('p14',    0, 1870),
  ('p15',    0, 1700),
  ('p16',    0, 2635)
) as v(id, mrp, cost)
where p.id = v.id and coalesce(p.mrp, 0) = 0 and coalesce(p.cost, 0) = 0;
