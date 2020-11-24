-- \connect "company";
SET client_encoding TO 'utf-8';

CREATE UNIQUE INDEX supervisor_idx ON company.supervisor (name, surname);

CREATE  INDEX invest_name_idx ON company.investment (name);

CREATE  INDEX sub_invest_name_idx ON company.sub_investment (name);

CREATE  INDEX sub_investment_start_date ON company.sub_investment (start_date);
CREATE  INDEX sub_investment_end_date ON company.sub_investment (end_date);

CREATE  INDEX investment_start_date ON company.investment (start_date);
CREATE  INDEX investment_end_date ON company.investment (end_date);