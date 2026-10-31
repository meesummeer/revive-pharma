-- Login step 1 of 2: let signed-in users read/write every table.
-- Additive and safe to run BEFORE the login version of the app is pushed:
-- the old anon policies keep the current live site working meanwhile.
-- Safe to re-run (each policy is dropped first).

alter table pharmas         enable row level security;
alter table bills           enable row level security;
alter table products        enable row level security;
alter table hcloud_invoices enable row level security;

drop policy if exists "auth_all_pharmas" on pharmas;
create policy "auth_all_pharmas" on pharmas for all to authenticated using (true) with check (true);

drop policy if exists "auth_all_bills" on bills;
create policy "auth_all_bills" on bills for all to authenticated using (true) with check (true);

drop policy if exists "auth_all_products" on products;
create policy "auth_all_products" on products for all to authenticated using (true) with check (true);

drop policy if exists "auth_all_hcloud_invoices" on hcloud_invoices;
create policy "auth_all_hcloud_invoices" on hcloud_invoices for all to authenticated using (true) with check (true);
