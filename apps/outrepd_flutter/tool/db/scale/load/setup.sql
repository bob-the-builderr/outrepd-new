-- Never run against the real project. See ../README.md.
-- A call that may be refused (a search from somebody already paired, say)
-- must not stop a phone in the load test: pgbench drops a client on its
-- first error. Timed all the same.
create or replace function load_try(q text)
returns void
language plpgsql
as $$
begin
  execute q;
exception when others then
  null;
end;
$$;
grant execute on function load_try(text) to authenticated;
create extension if not exists pg_stat_statements;
select pg_stat_statements_reset();
