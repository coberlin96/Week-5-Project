CREATE TABLE IF NOT EXISTS salesperson(
    salesperson_id SERIAL PRIMARY KEY,
    first_name VARCHAR(45),
    last_name VARCHAR(45)
);

CREATE TABLE IF NOT EXISTS customer(
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(45),
    last_name VARCHAR(45)
);

CREATE TABLE IF NOT EXISTS mechanic(
    mechanic_id SERIAL PRIMARY KEY,
    first_name VARCHAR(45),
    last_name VARCHAR(45)
);

CREATE TABLE IF NOT EXISTS parts(
    parts_id SERIAL PRIMARY KEY,
    part_name VARCHAR(30),
    part_cost NUMERIC(6,2)
);

CREATE TABLE IF NOT EXISTS car(
    car_id SERIAL PRIMARY KEY,
    make VARCHAR(25),
    model VARCHAR(25),
    year_ INTEGER,
    color VARCHAR(25),
    new_car_cost NUMERIC(10,2)
);

CREATE TABLE IF NOT EXISTS services(
    service_id SERIAL PRIMARY KEY,
    service_name VARCHAR(50),
    service_cost NUMERIC (10,2)
);

CREATE TABLE IF NOT EXISTS new_car_invoice(
    car_invoice_id SERIAL PRIMARY KEY,
    purchase_date DATE DEFAULT CURRENT_DATE,
    salesperson_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    car_id INTEGER NOT NULL,
    FOREIGN KEY (salesperson_id) REFERENCES salesperson(salesperson_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (car_id) REFERENCES car(car_id)
);

CREATE TABLE IF NOT EXISTS service_invoice(
    service_invoice_id SERIAL PRIMARY KEY,
    service_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    car_id INTEGER NOT NULL,
    parts_id INTEGER,
    mechanic_id INTEGER NOT NULL,
    FOREIGN KEY(service_id) REFERENCES services(service_id),
    FOREIGN KEY(customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY(car_id) REFERENCES car(car_id),
    FOREIGN KEY(parts_id) REFERENCES parts(parts_id),
    FOREIGN KEY(mechanic_id) REFERENCES mechanic(mechanic_id)
);

CREATE TABLE IF NOT EXISTS service_history(
    service_hx_id SERIAL PRIMARY KEY,
    car_id INTEGER NOT NULL,
    service_tx_id INTEGER NOT NULL,
    FOREIGN KEY(car_id) REFERENCES car(car_id),
    FOREIGN KEY(service_tx_id) REFERENCES service_invoice(service_invoice_id)
);

-- Functions for all tables with foreign keys

CREATE OR REPLACE FUNCTION create_new_car_invoice(_salesperson_id INTEGER, _customer_id INTEGER,
                                                 _car_id INTEGER)
RETURNS void
AS $MAIN$
BEGIN
    INSERT INTO new_car_invoice VALUES (DEFAULT, DEFAULT, _salesperson_id, _customer_id, _car_id);
END;
$MAIN$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_service_invoice(_service_id INTEGER, _customer_id INTEGER, _car_id INTEGER,
                                                 _parts_id INTEGER, _mechanic_id INTEGER)
RETURNS void
AS $MAIN$
BEGIN
    INSERT INTO service_invoice VALUES (DEFAULT, _service_id, _customer_id, _car_id, _parts_id, _mechanic_id);
END;
$MAIN$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_service_history(_car_id INTEGER, _service_tx_id INTEGER)
RETURNS void
AS $MAIN$
BEGIN
    INSERT INTO service_history values (DEFAULT, _car_id, _service_tx_id);
END;
$MAIN$
LANGUAGE plpgsql;

-- Inserting data into every table

INSERT INTO customer VALUES (DEFAULT, 'Aaron', 'Brooks');
INSERT INTO customer VALUES (DEFAULT, 'Terrance', 'Howard');

INSERT INTO car VALUES (DEFAULT, 'Honda', 'CR-V', 2011, 'Red', 6000.00);
INSERT INTO car VALUES (DEFAULT, 'Toyota', 'Camry', 2019, 'Blue', 18000.00);

INSERT INTO mechanic VALUES (DEFAULT, 'Randy', 'Norton');
INSERT INTO mechanic VALUES (DEFAULT, 'Shawn', 'Bigsby');

INSERT INTO parts VALUES (DEFAULT, 'Rotary Arm', 249.99);
INSERT INTO parts VALUES (DEFAULT, 'Hub Cap', 99.99);

INSERT INTO salesperson VALUES (DEFAULT, 'Richard', 'Darington');
INSERT INTO salesperson VALUES (DEFAULT, 'Vaugn', 'Riggles');

INSERT INTO services VALUES (DEFAULT, 'Tire Rotation', 119.99);
INSERT INTO services VALUES (DEFAULT, 'Oil Change', 49.99);

SELECT create_new_car_invoice(1,1,1);
SELECT create_new_car_invoice(2,2,2);

SELECT create_service_invoice(2,1,1,NULL,2);
SELECT create_service_invoice(1,2,2,1,1);

SELECT create_service_history(1,1);
SELECT create_service_history(2,2);