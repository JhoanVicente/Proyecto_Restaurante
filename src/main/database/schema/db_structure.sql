CREATE DATABASE dbLosPinos;
GO
USE dbLosPinos;
GO

CREATE TABLE category
(
    id_category int IDENTITY(1,1),
    name name_v NOT NULL,
    status defaultStatus_b DEFAULT 1 NOT NULL,
    CONSTRAINT category_pk PRIMARY KEY  (id_category),
    CONSTRAINT uq_category_name UNIQUE (name),
    CONSTRAINT chk_category_name_length CHECK (LEN(name) > 0 AND LEN(name) <= 90)
);
GO
CREATE TABLE product
(
    id_product productid_i IDENTITY(1,1) NOT NULL,
    id_category int NOT NULL,
    image VARCHAR(255) DEFAULT 'default.jpg',
    name name_v NOT NULL,
    note note_v NOT NULL,
    price price_d NOT NULL,
    date_p datatime_d NOT NULL,
    id_user userid_i NOT NULL,
    status defaultStatus_b DEFAULT 1 NOT NULL,
    CONSTRAINT product_pk PRIMARY KEY (id_product),
    CONSTRAINT chk_product_name_length CHECK (LEN(name) > 0 AND LEN(name) <= 90),
    CONSTRAINT chk_product_price_positive CHECK (price > 0),
    CONSTRAINT chk_product_status_bit CHECK (status IN (0, 1)),
    CONSTRAINT uq_product_name UNIQUE (name)
);
GO
CREATE TABLE client_reservation
(
    id_client_reservation int IDENTITY(1,1),
    id_user userid_i NOT NULL,
    name_reservation name_v NOT NULL,
    date_time datatime_d NOT NULL,
    quantity_people int NOT NULL,
    note note_v NOT NULL,
    id_type_status typestatus_i DEFAULT 1 NOT NULL,
    CONSTRAINT client_reservation_pk PRIMARY KEY  (id_client_reservation),
    CONSTRAINT chk_client_reservation_quantity_people CHECK (quantity_people > 0),
);
GO
CREATE TABLE ticket_sale
(
    id_ticket int IDENTITY(1,1),
    date_time datatime_d NOT NULL,
    id_user userid_i NOT NULL,
    total_pay price_d NOT NULL,
    is_delivery bit default 1 NOT NULL,
    address_delivery varchar(150),
    note note_v NOT NULL,
    id_type_payment int NOT NULL,
    id_type_status typestatus_i default 1,
    CONSTRAINT ticket_sale_pk PRIMARY KEY (id_ticket),
    CONSTRAINT chk_ticket_sale_total_pay CHECK (total_pay > 0),
    CONSTRAINT chk_ticket_sale_is_delivery CHECK (is_delivery IN (0, 1)),
    CONSTRAINT chk_ticket_sale_address_length CHECK (LEN(address_delivery) <= 150),
);
GO
CREATE TABLE detail_product
(
    id_detail_product int IDENTITY(1,1),
    id_ticket int NOT NULL,
    id_product productid_i NOT NULL,
    quantity int NOT NULL,
    price_sale price_d NOT NULL,
    CONSTRAINT detail_product_pk PRIMARY KEY  (id_detail_product),
    CONSTRAINT chk_detail_product_quantity CHECK (quantity > 0),
    CONSTRAINT chk_detail_product_price_sale CHECK (price_sale > 0)
);
GO
CREATE TABLE type_payment
(
    id_type_payment int IDENTITY(1,1),
    name name_v NOT NULL,
    CONSTRAINT type_payment_pk PRIMARY KEY (id_type_payment),
    CONSTRAINT uq_type_payment_name UNIQUE (name),
    CONSTRAINT chk_type_payment_name_length CHECK (LEN(name) > 0 AND LEN(name) <= 90)
);
GO
CREATE TABLE type_status_order
(
    id_type_status typestatus_i IDENTITY(1,1),
    name name_v NOT NULL,
    CONSTRAINT type_status_order_pk PRIMARY KEY  (id_type_status),
    CONSTRAINT uq_type_status_order_name UNIQUE (name),
    CONSTRAINT chk_type_status_order_name_length CHECK (LEN(name) > 0 AND LEN(name) <= 90)
);
GO
CREATE TABLE type_user
(
    id_type_user int IDENTITY(1,1),
    name name_v NOT NULL,
    CONSTRAINT type_user_pk PRIMARY KEY  (id_type_user),
    CONSTRAINT uq_type_user_name UNIQUE (name),
    CONSTRAINT chk_type_user_name_length CHECK (LEN(name) > 0 AND LEN(name) <= 90)
);
GO
CREATE TABLE user_restaurant
(
    id_user userid_i IDENTITY(1,1) NOT NULL,
    username VARCHAR(20) NOT NULL,
    password name_v NOT NULL,
    names name_v NOT NULL,
    lastnames name_v NOT NULL,
    date_birth date NOT NULL,
    address varchar(150) NOT NULL,
    phone char(9) NOT NULL,
    email varchar(150) NOT NULL,
    number_identification varchar(20) NOT NULL,
    type_document varchar(5) NOT NULL,
    id_type_user int NOT NULL,
    status defaultStatus_b DEFAULT 1 NOT NULL,
    email_verified defaultStatus_b DEFAULT 0 NOT NULL,
    CONSTRAINT user_restaurant_pk PRIMARY KEY  (id_user),
    CONSTRAINT uq_user_name UNIQUE (username),
    CONSTRAINT uq_user_email UNIQUE (email),
    CONSTRAINT uq_user_number_identification UNIQUE (number_identification),  -- actualización de la tabla user_restaurant para agregar la restricción de unicidad en el número de identificación
    CONSTRAINT chk_user_phone_length CHECK (LEN(phone) = 9),
    CONSTRAINT chk_user_email_format CHECK (email LIKE '%@%.%'),
    CONSTRAINT chk_user_status CHECK (status IN (0, 1)) --  CONSTRAINT chk_user_status CHECK (status IN ('activo', 'inactivo'))
);
GO
-- Reference: Clientes_Reservas_Cliente (table: client_reservation)
ALTER TABLE client_reservation ADD CONSTRAINT Clientes_Reservas_Cliente
    FOREIGN KEY (id_user)
        REFERENCES user_restaurant (id_user);

-- Reference: Clientes_Reservas_Tipo_Estado_Reserva (table: client_reservation)
ALTER TABLE client_reservation ADD CONSTRAINT Clientes_Reservas_Tipo_Estado_Reserva
    FOREIGN KEY (id_type_status)
        REFERENCES type_status_order (id_type_status);


-- Reference: Detalles_pedido_Insumo (table: detail_product)
ALTER TABLE detail_product ADD CONSTRAINT Detalles_pedido_Insumo
    FOREIGN KEY (id_product)
        REFERENCES product (id_product);

-- Reference: Detalles_pedido_Pedido (table: detail_product)
ALTER TABLE detail_product ADD CONSTRAINT Detalles_pedido_Pedido
    FOREIGN KEY (id_ticket)
        REFERENCES ticket_sale (id_ticket);

-- Reference: Insumo_Categoria (table: product)
ALTER TABLE product ADD CONSTRAINT Insumo_Categoria
    FOREIGN KEY (id_category)
        REFERENCES category (id_category);

-- Reference: Pedido_Cliente (table: ticket_sale)
ALTER TABLE ticket_sale ADD CONSTRAINT Pedido_Cliente
    FOREIGN KEY (id_user)
        REFERENCES user_restaurant (id_user);

-- Reference: Pedido_Metodo_de_Pago (table: ticket_sale)restaurante.dbo
ALTER TABLE ticket_sale ADD CONSTRAINT Pedido_Metodo_de_Pago
    FOREIGN KEY (id_type_payment)
        REFERENCES type_payment (id_type_payment);

-- Reference: menu_item_user (table: product)
ALTER TABLE product ADD CONSTRAINT menu_item_user
    FOREIGN KEY (id_user)
        REFERENCES user_restaurant (id_user);


-- Reference: ticket_sale_type_status_order (table: ticket_sale)
ALTER TABLE ticket_sale ADD CONSTRAINT ticket_sale_type_status_order
    FOREIGN KEY (id_type_status)
        REFERENCES type_status_order (id_type_status);

-- Reference: user_type_user (table: user_restaurant)
ALTER TABLE user_restaurant ADD CONSTRAINT user_type_user
    FOREIGN KEY (id_type_user)
        REFERENCES type_user (id_type_user);