CREATE TABLE category (
    id_category int  NOT NULL,
    name varchar(50)  NOT NULL,
    CONSTRAINT category_pk PRIMARY KEY  (id_category)
);

-- Table: client_reservation
CREATE TABLE client_reservation (
    id_client_reservation int  NOT NULL,
    id_user int  NOT NULL,
    name_reservation varchar(50)  NOT NULL,
    datetime datetime  NOT NULL,
    quantity_people int  NOT NULL,
    nota text  NOT NULL,
    id_type_status int  NOT NULL,
    CONSTRAINT client_reservation_pk PRIMARY KEY  (id_client_reservation)
);

-- Table: detail_product
CREATE TABLE detail_product (
    id_detail_product int  NOT NULL,
    id_ticket int  NOT NULL,
    id_product int  NOT NULL,
    quantity int  NOT NULL,
    price_sale decimal(6,2)  NOT NULL,
    CONSTRAINT detail_product_pk PRIMARY KEY  (id_detail_product)
);

-- TABLA MAESTRA PRODUCT
CREATE TABLE productDto (
    id_product int NOT NULL,
    id_category int NOT NULL,
    image varchar(155) NOT NULL,
    name varchar(50) NOT NULL,
    description varchar(50) NOT NULL,
    price decimal(6,2) NOT NULL,
    date date NOT NULL,
    id_user int NOT NULL,
    status bit NOT NULL,
    CONSTRAINT product_pk PRIMARY KEY (id_product),
    CONSTRAINT chk_product_name_length CHECK (LEN(name) > 0 AND LEN(name) <= 50),
    CONSTRAINT chk_product_description_length CHECK (LEN(description) > 0 AND LEN(description) <= 50),
    CONSTRAINT chk_product_price_positive CHECK (price > 0),
    CONSTRAINT chk_product_status_bit CHECK (status IN (0, 1)),
    CONSTRAINT uq_product_name UNIQUE (name),
    CONSTRAINT uq_product_image UNIQUE (image)
);


-- Table: temp_detail_product
CREATE TABLE temp_detail_product (
    id_temp_product int  NOT NULL,
    token_user varchar(150)  NOT NULL,
    id_product int  NOT NULL,
    quantity int  NOT NULL,
    price_sale decimal(6,2)  NOT NULL,
    CONSTRAINT temp_detail_product_pk PRIMARY KEY  (id_temp_product)
);

-- Table: ticket_sale
CREATE TABLE ticket_sale (
    id_ticket int  NOT NULL,
    datetime datetime  NOT NULL,
    id_user int  NOT NULL,
    total_pay decimal(6,2)  NOT NULL,
    is_delivery bit  NOT NULL,
    address_delivery varchar(80)  NOT NULL,
    note varchar(50)  NOT NULL,
    id_type_payment int  NOT NULL,
    code_payment varchar(8)  NOT NULL,
    id_type_status int  NOT NULL,
    CONSTRAINT ticket_sale_pk PRIMARY KEY  (id_ticket)
);

-- Table: type_payment
CREATE TABLE type_payment (
    id_type_payment int  NOT NULL,
    name varchar(50)  NOT NULL,
    CONSTRAINT type_payment_pk PRIMARY KEY  (id_type_payment)
);

-- Table: type_status_order
CREATE TABLE type_status_order (
    id_type_status int  NOT NULL,
    name varchar(50)  NOT NULL,
    CONSTRAINT type_status_order_pk PRIMARY KEY  (id_type_status)
);

-- Table: type_user
CREATE TABLE type_user (
    id_type_user int  NOT NULL,
    name varchar(50)  NOT NULL,
    CONSTRAINT type_user_pk PRIMARY KEY  (id_type_user)
);

CREATE TABLE "userDto" (
    id_user int NOT NULL,
    username varchar(50) NOT NULL,
    password varchar(155) NOT NULL,
    names varchar(50) NOT NULL,
    lastnames varchar(50) NOT NULL,
    date_birth date NOT NULL,
    address varchar(50) NOT NULL,
    phone char(9) NOT NULL,
    email varchar(50) NOT NULL,
    number_identification varchar(12) NOT NULL,
    type_document varchar(5) NOT NULL,
    id_type_user int NOT NULL,
    status bit NOT NULL,
    CONSTRAINT user_pk PRIMARY KEY (id_user),
    CONSTRAINT uq_user_username UNIQUE (username), -- Username debe ser único
    CONSTRAINT uq_user_email UNIQUE (email), -- Email debe ser único
    CONSTRAINT chk_user_phone_length CHECK (LEN(phone) = 9), -- Longitud exacta del teléfono
    CONSTRAINT chk_user_email_format CHECK (email LIKE '%@%.%'), -- Formato de email válido
    CONSTRAINT chk_user_status CHECK (status IN (0, 1)) -- Status debe ser 0 o 1
);


-- foreign keys
-- Reference: Clientes_Reservas_Cliente (table: client_reservation)
ALTER TABLE client_reservation ADD CONSTRAINT Clientes_Reservas_Cliente
    FOREIGN KEY (id_user)
    REFERENCES "userDto" (id_user);

-- Reference: Clientes_Reservas_Tipo_Estado_Reserva (table: client_reservation)
ALTER TABLE client_reservation ADD CONSTRAINT Clientes_Reservas_Tipo_Estado_Reserva
    FOREIGN KEY (id_type_status)
    REFERENCES type_status_order (id_type_status);

-- Reference: Detalles_pedido_Insumo (table: detail_product)
ALTER TABLE detail_product ADD CONSTRAINT Detalles_pedido_Insumo
    FOREIGN KEY (id_product)
    REFERENCES productDto (id_product);

-- Reference: Detalles_pedido_Pedido (table: detail_product)
ALTER TABLE detail_product ADD CONSTRAINT Detalles_pedido_Pedido
    FOREIGN KEY (id_ticket)
    REFERENCES ticket_sale (id_ticket);

-- Reference: Insumo_Categoria (table: productDto)
ALTER TABLE productDto ADD CONSTRAINT Insumo_Categoria
    FOREIGN KEY (id_category)
    REFERENCES category (id_category);

-- Reference: Pedido_Cliente (table: ticket_sale)
ALTER TABLE ticket_sale ADD CONSTRAINT Pedido_Cliente
    FOREIGN KEY (id_user)
    REFERENCES "userDto" (id_user);

-- Reference: Pedido_Metodo_de_Pago (table: ticket_sale)
ALTER TABLE ticket_sale ADD CONSTRAINT Pedido_Metodo_de_Pago
    FOREIGN KEY (id_type_payment)
    REFERENCES type_payment (id_type_payment);

-- Reference: menu_item_user (table: productDto)
ALTER TABLE productDto ADD CONSTRAINT menu_item_user
    FOREIGN KEY (id_user)
    REFERENCES "userDto" (id_user);

-- Reference: temp_detail_item_menu_item (table: temp_detail_product)
ALTER TABLE temp_detail_product ADD CONSTRAINT temp_detail_item_menu_item
    FOREIGN KEY (id_product)
    REFERENCES productDto (id_product);

-- Reference: ticket_sale_type_status_order (table: ticket_sale)
ALTER TABLE ticket_sale ADD CONSTRAINT ticket_sale_type_status_order
    FOREIGN KEY (id_type_status)
    REFERENCES type_status_order (id_type_status);

-- Reference: user_type_user (table: userDto)
ALTER TABLE "userDto" ADD CONSTRAINT user_type_user
    FOREIGN KEY (id_type_user)
    REFERENCES type_user (id_type_user);

-- End of file.

-- *****************============= SIMULANDO EL CRUD  *****************=============

-- Operación CREATE (Insertar un Nuevo Producto)

-- Insertar un nuevo producto en la tabla productDto
INSERT INTO productDto (id_product, id_category, image, name, description, price, date, id_user, status)
VALUES (1, 1, 'url_imagen.jpg', 'Producto de Ejemplo', 'Descripción del Producto', 19.99, '2024-05-03', 1, 1);


-- Operación READ (Consultar Productos)

-- Consultar todos los productos
SELECT * FROM productDto;

-- Consultar un producto específico por ID
SELECT * FROM productDto WHERE id_product = 1;

-- Consultar productos de una categoría específica
SELECT * FROM productDto WHERE id_category = 1;

-- Operación UPDATE (Actualizar un Producto)

-- Actualizar información de un producto existente
UPDATE productDto
SET name = 'Nuevo Nombre', price = 24.99
WHERE id_product = 1;

-- Operación DELETE (Eliminación Lógica de un Producto)
-- Cambiar el estado del producto a inactivo (eliminación lógica)
UPDATE productDto
SET is_active = 0
WHERE id_product = 1;
  