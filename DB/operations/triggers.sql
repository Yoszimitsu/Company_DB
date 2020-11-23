-- \connect "company";
SET client_encoding TO 'utf-8';

CREATE OR REPLACE FUNCTION company.clear_sub_investement() RETURNS TRIGGER AS $$
   BEGIN
      DELETE FROM company.product_order WHERE sub_investment_id = (
        SELECT sub_investment_id FROM company.sub_investment WHERE investment_id = OLD.investment_id);
      DELETE FROM company.sub_investment WHERE investment_id = OLD.investment_id;
      RETURN OLD;
   END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER clear_sub_investement BEFORE DELETE ON company.investment
FOR EACH ROW EXECUTE PROCEDURE company.clear_sub_investement();


SET TIMEZONE='GMT';

CREATE TABLE company.log_price_update(
    log_id BIGSERIAL NOT NULL,
    log_date TIMESTAMP NOT NULL,
    product_id INTEGER NOT NULL,
    product_name VARCHAR(50) NOT NULL,
    old_price NUMERIC(8,2) NOT NULL,
    new_price NUMERIC(8,2) NOT NULL,
    product_producer VARCHAR(50) NOT NULL);

CREATE OR REPLACE FUNCTION company.log_price_update() RETURNS TRIGGER AS $$
   BEGIN
     INSERT INTO company.log_price_update (log_date, product_id, product_name, old_price, new_price, product_producer)
     VALUES (NOW(), OLD.product_id, OLD.name, OLD.price_net, NEW.price_net, OLD.producer_id);
      RETURN OLD;
      RETURN NEW;
   END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER log_price_update_trigger AFTER UPDATE ON company.product
FOR EACH ROW EXECUTE PROCEDURE company.log_price_update();





