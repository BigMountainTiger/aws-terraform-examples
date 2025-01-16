-- https://docs.aws.amazon.com/redshift/latest/dg/r_STV_LOCKS.html
-- https://docs.aws.amazon.com/redshift/latest/dg/r_SVV_TRANSACTIONS.html
-- https://docs.aws.amazon.com/redshift/latest/dg/r_SVV_TABLE_INFO.html


select * from svv_table_info limit 1;

select lk.table_id, t.schema, t.table, lk.last_update, lk.lock_owner, lk.lock_owner_pid
from stv_locks lk 
	join svv_table_info t on lk.table_id = t.table_id
order by t.schema, t.table;


select tb.schema, tb.table, *
from svv_transactions tr
	left join svv_table_info tb on tr.relation = tb.table_id
where tb.table_id is not null
order by tb.schema, tb.table;