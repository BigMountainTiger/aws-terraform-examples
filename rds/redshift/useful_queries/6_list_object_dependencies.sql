with depdendency as (
	select distinct
		srcnsp.nspname depending_schema,
		srcobj.relname depending_object,
		srcobj.relkind depending_object_type,
		tgtnsp.nspname depended_schema,
		tgtobj.relname depended_object,
		tgtobj.relkind depended_object_type
	from 
	pg_catalog.pg_depend d
	join pg_catalog.pg_class srcobj on d.objid = srcobj.oid
	join pg_catalog.pg_namespace srcnsp on srcobj.relnamespace = srcnsp.oid
	join pg_catalog.pg_class tgtobj on d.refobjid = tgtobj.oid
	join pg_catalog.pg_namespace tgtnsp on tgtobj.relnamespace = tgtnsp.oid
	where srcnsp.nspname not like 'pg_%' and tgtnsp.nspname not like 'pg_%'
)
select *  from depdendency;