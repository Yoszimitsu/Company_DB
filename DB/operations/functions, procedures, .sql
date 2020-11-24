-- \connect "company";
SET client_encoding TO 'utf-8';

CREATE OR REPLACE FUNCTION company.address() RETURNS VARCHAR
LANGUAGE SQL
AS $$
    SELECT
	CONCAT('st. ', p.street, ' ',number, ' ,', post_code, ' ,', city, ' ,', country)
	FROM company.place_object AS p;
$$;

CREATE OR REPLACE PROCEDURE company.new_employee(name_new VARCHAR(50), surname_new VARCHAR(50), position_new VARCHAR(15),
 phone_new VARCHAR(15), email_new VARCHAR(70))
LANGUAGE SQL
AS $$
        INSERT INTO company.supervisor(
        name,
        surname,
        position,
        phone,
        email)
        VALUES (name_new, surname_new, position_new, phone_new, email_new);
$$;


CREATE OR REPLACE PROCEDURE company.new_product_and_producer(
product_name VARCHAR(50), price_net NUMERIC(8,2), type_a BOOLEAN, type_b BOOLEAN,
producer_name VARCHAR(50), type_a_discount NUMERIC(3,2), type_b_discount NUMERIC(3,2))
AS $$
declare
    v_state   TEXT;
    v_msg     TEXT;
    v_detail  TEXT;
    v_hint    TEXT;
    v_context TEXT;
    begin

        INSERT INTO company.producer(
            name,
            type_a_discount,
            type_b_discount)
        VALUES(
            producer_name,
            type_a_discount,
            type_b_discount);

        INSERT INTO company.product(
            producer_id,
            name,
            price_net,
            type_a,
            type_b)
        VALUES(
            (SELECT producer_id FROM company.producer WHERE name = producer_name),
            product_name,
            price_net,
            type_a,
            type_b);

    exception when others then

        get stacked diagnostics
            v_state   = returned_sqlstate,
            v_msg     = message_text,
            v_detail  = pg_exception_detail,
            v_hint    = pg_exception_hint,
            v_context = pg_exception_context;

        raise notice E'Got exception:
            state  : %
            message: %
            detail : %
            hint   : %
            context: %', v_state, v_msg, v_detail, v_hint, v_context;

        raise notice E'Got exception:
            SQLSTATE: %
            SQLERRM: %', SQLSTATE, SQLERRM;

        raise notice '%', v_msg;

    end;
$$ LANGUAGE plpgsql;


-- TODO
-- CREATE OR REPLACE FUNCTION company.product_type_disc() RETURNS TABLE (discount NUMERIC(3,2))
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     CASE
--       WHEN (COALESCE((SELECT type_a FROM company.product), false)) IS TRUE THEN
--                 SELECT type_a_discount FROM company.producer;
--       WHEN  (COALESCE((SELECT type_b FROM company.product), false)) IS TRUE THEN
--                 SELECT type_b_discount FROM company.producer;
--       ELSE
--
--     END CASE;
-- END
-- $$;