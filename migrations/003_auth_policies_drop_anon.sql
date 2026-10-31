-- Login step 2 of 2: remove public (anon key) access.
-- Run AFTER the login version of the app is live and you've signed in once.
-- Drops every policy on the app's tables that applies to `anon` or `public`
-- (dashboard-made policies default to `public`), whatever it is named.
-- The `authenticated` policies from 002 are left in place. Safe to re-run.

alter table pharmas         enable row level security;
alter table bills           enable row level security;
alter table products        enable row level security;
alter table hcloud_invoices enable row level security;

do $$
declare r record;
begin
  for r in
    select tablename, policyname from pg_policies
    where schemaname = 'public'
      and tablename in ('pharmas', 'bills', 'products', 'hcloud_invoices')
      and roles && array['anon', 'public']::name[]
  loop
    raise notice 'Dropping policy "%" on %', r.policyname, r.tablename;
    execute format('drop policy %I on public.%I', r.policyname, r.tablename);
  end loop;
end $$;

-- Check: every row should list only {authenticated}, and rls_on should be true.
select p.tablename, p.policyname, p.roles, c.relrowsecurity as rls_on
from pg_policies p
join pg_class c on c.relname = p.tablename and c.relnamespace = 'public'::regnamespace
where p.schemaname = 'public'
  and p.tablename in ('pharmas', 'bills', 'products', 'hcloud_invoices')
order by p.tablename;
