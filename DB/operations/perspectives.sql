-- \connect "company";
SET client_encoding TO 'utf-8';

CREATE VIEW company.product_orders_value as
SELECT
	c.sub_investment_id,
	s.name sub_investment_name,
	p.name product_name,
	a.price_net,
	( ROUND(a.price_net *
	 (1 - CASE
	  WHEN (COALESCE(a.type_a, false)) IS TRUE THEN
	            b.type_a_discount
	  WHEN  (COALESCE(a.type_b, false)) IS TRUE THEN
	            b.type_b_discount
      ELSE
                0
      END
	 ),2)
	 ) after_discount,
	c.quantity,
	ROUND(
	ROUND(a.price_net *
	 (1 - CASE
	  WHEN (COALESCE(a.type_a, false)) IS TRUE THEN
	            b.type_a_discount
	  WHEN  (COALESCE(a.type_b, false)) IS TRUE THEN
	            b.type_b_discount
      ELSE
                0
      END
	 ),2) * c.quantity, 2) value_net
FROM company.product_order c
INNER JOIN company.product a
ON c.product_id = a.product_id
INNER JOIN company.sub_investment s
ON c.sub_investment_id = s.sub_investment_id
INNER JOIN company.product p
ON a.product_id = p.product_id
INNER JOIN company.producer b
ON a.producer_id = b.producer_id
ORDER BY c.product_id;


CREATE OR REPLACE VIEW company.investment_info as
SELECT
	c.investment_id,
	c.name,
	k.company_name client,
	company.address_procedure() address,
	c.start_date,
	c.end_date,
	CONCAT(s.name, ' ', s.surname) supervisor
FROM company.investment c
INNER JOIN company.place_object p
ON c.place_object_id = p.place_object_id
INNER JOIN company.supervisor s
ON c.supervisor_id = s.supervisor_id
INNER JOIN company.client k
ON c.client_id = k.client_id
ORDER BY c.investment_id;
