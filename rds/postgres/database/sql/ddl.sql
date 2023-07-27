DROP table if exists public.example;

CREATE TABLE public.example (
	id int8 NOT NULL GENERATED ALWAYS AS IDENTITY,
	field_1 varchar(255) NULL,
	field_2 varchar(255) NULL,
	field_3 varchar(255) NULL,
	field_4 varchar(255) NULL,
	field_5 varchar(255) NULL,
	CONSTRAINT example_pk PRIMARY KEY (id)
);

CREATE OR REPLACE FUNCTION public.insert_into_example(count int8)
	RETURNS int8
	LANGUAGE plpgsql
AS $$
DECLARE
	current_max int8;
	field_value varchar(255);
BEGIN
	select coalesce(MAX(id), 0) into current_max from public.example;

	for i in (current_max + 1) .. (current_max + count) loop
		field_value := concat('F-', i::varchar);
		insert into public.example(field_1, field_2, field_3, field_4, field_5)
			values (field_value, field_value, field_value, field_value, field_value);
	end loop;

	return current_max + count;

END; $$;