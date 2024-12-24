-- https://www.postgresql.org/docs/current/plpgsql-structure.html

-- <<outerblock>> is the label

create or replace FUNCTION somefunc() RETURNS integer AS $$
<<outerblock>>
DECLARE
    quantity integer := 30;
BEGIN
    RAISE NOTICE 'Quantity here is %', quantity;
    quantity := 50;

    DECLARE
        quantity integer := 80;
    BEGIN
        RAISE NOTICE 'Quantity here is %', quantity;
		
		-- access the variable in the outer block
        RAISE NOTICE 'Outer quantity here is %', outerblock.quantity;
    END;

    RAISE NOTICE 'Quantity here is %', quantity;

    RETURN quantity;
END;
$$ LANGUAGE plpgsql;

select somefunc();


