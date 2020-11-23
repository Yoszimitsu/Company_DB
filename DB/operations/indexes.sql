-- \connect "company";
SET client_encoding TO 'utf-8';

CREATE UNIQUE INDEX supervisor_idx ON company.supervisor (name, surname);

CREATE  INDEX invest_name_idx ON company.investment (name);

CREATE  INDEX sub_invest_name_idx ON company.sub_investment (name);