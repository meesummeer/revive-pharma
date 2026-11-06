-- Allow the 'due-now' bill status.
-- Finds the old status check by what it covers rather than by name. Safe to re-run.

do $$
declare r record;
begin
  for r in
    select conname from pg_constraint
    where conrelid = 'public.bills'::regclass
      and contype = 'c'
      and pg_get_constraintdef(oid) ilike '%status%'
  loop
    execute format('alter table public.bills drop constraint %I', r.conname);
  end loop;
end $$;

alter table public.bills add constraint bills_status_check
  check (status in ('paid', 'unpaid', 'due-now'));

-- Check: should show paid, unpaid and due-now.
select conname, pg_get_constraintdef(oid) from pg_constraint
where conrelid = 'public.bills'::regclass and contype = 'c';
