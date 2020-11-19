-- \connect "company";

IF company.producer.typa_a_discount = 'true' then

SELECT 
	c.product_id,
	c.sub_investment_id,
	a.price_net,
	ROUND(a.price_net * (1 - b.type_a_discount), 2) after_discount,
	c.quantity,
	ROUND(ROUND(a.price_net * (1 - b.type_a_discount), 2) * c.quantity, 2) value_net
AS company.calculations
FROM company.product_order c
INNER JOIN company.product a
ON c.product_id = a.product_id
INNER JOIN company.producer b
ON a.producer_id = b.producer_id
ORDER BY c.product_id;

else if company.producer.typa_b_discount = 'true' then

SELECT 
	c.product_id,
	c.sub_investment_id,
	a.price_net,
	b.type_b_discount,
	ROUND(a.price_net * (1 - b.type_b_discount), 2) after_discount,
	c.quantity,
	ROUND(ROUND(a.price_net * (1 - b.type_b_discount), 2) * c.quantity, 2) value_net
FROM company.product_order c
INNER JOIN company.product a
ON c.product_id = a.product_id
INNER JOIN company.producer b
ON a.producer_id = b.producer_id
ORDER BY c.product_id;

else
SELECT

	c.product_id,
	c.sub_investment_id,
	a.price_net,
	c.quantity,
	ROUND(a.price_net * c.quantity, 2) value_net,
AS company.calculations
FROM company.product_order c
INNER JOIN company.product a
ON c.product_id = a.product_id
INNER JOIN company.producer b
ON a.producer_id = b.producer_id
ORDER BY c.product_id;

end if;


$$;