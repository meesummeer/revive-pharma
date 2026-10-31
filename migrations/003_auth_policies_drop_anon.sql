-- Login step 2 of 2: remove public (anon key) access.
-- Run AFTER the login version of the app is live and you've signed in once.

drop policy if exists "anon_all_pharmas"  on pharmas;
drop policy if exists "anon_all_bills"    on bills;
drop policy if exists "anon_all_products" on products;

-- Check: nothing should list {anon} or {public} in roles afterwards.
select tablename, policyname, roles from pg_policies where schemaname = 'public' order by tablename;
