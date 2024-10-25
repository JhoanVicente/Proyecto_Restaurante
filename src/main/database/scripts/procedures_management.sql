-- * Proceso Almacenado para gestión del Adminsitrador

-- Detalles de los Productos de un Ticket ID
CREATE PROCEDURE sp_OrderProductDetail
@TicketId INT
AS
BEGIN
    SELECT
        dp.quantity as 'Cantidad de producto',
        p.name as 'Nombre del producto',
        dp.price_sale as 'Precio de venta del producto'
    FROM
        product.detail_product dp
            JOIN
        product.product p ON dp.id_product = p.id_product
    WHERE
        dp.id_ticket = @TicketId;
END
GO

-- Crear el procedimiento almacenado para obtener todos los pedidos por estado
CREATE PROCEDURE sp_OrderViewAll
@StatusId INT
AS
BEGIN
    SELECT
        ts.id_ticket AS 'Id de ticket',
        ts.total_pay AS 'Total de pago',
        ts.date_time AS 'Fecha de la venta',
        CASE
            WHEN ts.is_delivery = 1 THEN 'Entrega a domicilio'
            ELSE 'Entrega en el Restaurante'
            END AS 'Método de entrega',
        tp.name AS 'Tipo de pago',
        tso.id_type_status AS 'Estado',
        u.names AS 'Nombres',
        u.lastnames AS 'Apellidos'
    FROM
        ticket_sale ts
            JOIN users.user_restaurant u ON ts.id_user = u.id_user
            JOIN type_payment tp ON ts.id_type_payment = tp.id_type_payment
            JOIN type_status_order tso ON ts.id_type_status = tso.id_type_status
    WHERE ts.id_type_status = @StatusId;
END
GO

-- * Proceso Almacenado para gestión el Cliente

-- Obtener todos los pedidos del cliente por estado y usuario
CREATE PROCEDURE sp_OrderViewForUser
    @UserId INT,
    @StatusId INT
AS
BEGIN
    SELECT
        ts.id_ticket AS 'Id de ticket',
        ts.total_pay AS 'Total de pago',
        ts.date_time AS 'Fecha de la venta',
        CASE
            WHEN ts.is_delivery = 1 THEN 'Entrega a domicilio'
            ELSE 'Entrega en el Restaurante'
            END AS 'Método de entrega',
        tp.name AS 'Tipo de pago',
        tso.name AS 'Estado',
        u.names AS 'Nombres',
        u.lastnames AS 'Apellidos'
    FROM
        ticket_sale ts
            JOIN users.user_restaurant u ON ts.id_user = u.id_user
            JOIN type_payment tp ON ts.id_type_payment = tp.id_type_payment
            JOIN type_status_order tso ON ts.id_type_status = tso.id_type_status
    WHERE
        u.id_user = @UserId AND ts.id_type_status = @StatusId;
END
GO


-- * Proceso Almacenado para obtener detalles de un ticket

CREATE PROCEDURE sp_OrderByTicketClient
@IdTicket INT
AS
BEGIN
    SELECT
        -- Datos del ticket ts
        ts.id_ticket AS 'Id de ticket',
        ts.total_pay AS 'Total de pago',
        ts.date_time AS 'Fecha de la venta',
        CASE
            WHEN ts.is_delivery = 1 THEN 'Entrega a domicilio'
            ELSE 'Entrega en el Restaurante'
            END AS 'Método de entrega',
        -- Datos del Type Payment tp
        tp.name AS 'Tipo de pago',
        -- Datos del Type Status Order tso
        tso.name AS 'Estado',
        -- Datos del usuario u
        u.names AS 'Nombres',
        u.lastnames AS 'Apellidos',
        u.email AS 'Correo electrónico',
        u.phone AS 'Teléfono',
        u.number_identification AS 'Número de identificación',
        u.type_document AS 'Tipo de documento',
        ts.address_delivery AS 'Dirección de entrega',
        ts.note AS 'Nota',
        u.id_user AS 'Id de usuario'
    FROM
        ticket_sale ts
            JOIN users.user_restaurant u ON ts.id_user = u.id_user
            JOIN type_payment tp ON ts.id_type_payment = tp.id_type_payment
            JOIN type_status_order tso ON ts.id_type_status = tso.id_type_status
    WHERE
        ts.id_ticket = @IdTicket;
END
GO


-- * Buscar pedidos por nombre del cliente
CREATE PROCEDURE sp_OrderViewByName
@Name NVARCHAR(255)
AS
BEGIN
    SELECT
        ts.id_ticket AS 'Id de ticket',
        ts.total_pay AS 'Total de pago',
        ts.date_time AS 'Fecha de la venta',
        CASE
            WHEN ts.is_delivery = 1 THEN 'Entrega a domicilio'
            ELSE 'Entrega en el Restaurante'
            END AS 'Método de entrega',
        tp.name AS 'Tipo de pago',
        tso.id_type_status AS 'Estado',
        u.names AS 'Nombres',
        u.lastnames AS 'Apellidos'
    FROM
        ticket_sale ts
            JOIN users.user_restaurant u ON ts.id_user = u.id_user
            JOIN type_payment tp ON ts.id_type_payment = tp.id_type_payment
            JOIN type_status_order tso ON ts.id_type_status = tso.id_type_status
    WHERE u.names LIKE '%' + @Name + '%';
END
GO

-- * Todos los Usuarios por paginación

CREATE PROCEDURE sp_UsersViewAllForPagination
    @StatusId INT,
    @PageNumber INT,
    @RowsPerPage INT
AS
BEGIN
    SELECT
        id_user,
        username,
        names,
        lastnames,
        phone,
        email,
        number_identification,
        type_document,
        id_type_user,
        status,
        email_verified
    FROM
        users.user_restaurant
    WHERE
        status = @StatusId
    ORDER BY
        id_user
    OFFSET (@PageNumber - 1) * @RowsPerPage ROWS
        FETCH NEXT @RowsPerPage ROWS ONLY;
END
GO


--* Todos los pedidos por páginación
CREATE PROCEDURE sp_OrderViewAllForPagination
    @StatusId INT,
    @PageNumber INT,
    @RowsPerPage INT
AS
BEGIN
    SELECT
        ts.id_ticket as 'Id de ticket',
        ts.total_pay as 'Total de pago',
        ts.date_time as 'Fecha de la venta',
        CASE
            WHEN ts.is_delivery = 1 THEN 'Entrega a domicilio'
            ELSE 'Entrega en el Restaurante'
            END as 'Metodo de entrega',
        tp.name as 'Tipo de pago',
        tso.id_type_status as 'Estado',
        u.names as 'Nombres',
        u.lastnames as 'Apellidos'
    FROM
        ticket_sale ts
            JOIN
        users.user_restaurant u ON ts.id_user = u.id_user
            JOIN
        type_payment tp ON ts.id_type_payment = tp.id_type_payment
            JOIN
        type_status_order tso ON ts.id_type_status = tso.id_type_status
    WHERE
        ts.id_type_status = @StatusId
    ORDER BY
        ts.id_ticket
    OFFSET (@PageNumber - 1) * @RowsPerPage ROWS
        FETCH NEXT @RowsPerPage ROWS ONLY;
END
GO

--* Cuenta el total de filas de la tabla ticket_sale
CREATE PROCEDURE sp_GetTotalRows
@StatusId INT
AS
BEGIN
    SELECT COUNT(*) AS TotalRows
    FROM ticket_sale
    WHERE id_type_status = @StatusId;
END
GO

-- Ejecutar el procedimiento para obtener los pedidos paginados
EXECUTE sp_OrderViewAllForPagination 1, 1, 5;

-- Seleccionar todos los usuarios de la tabla user_restaurant
SELECT * FROM users.user_restaurant;

-- Seleccionar usuarios con estado activo
SELECT
    id_user,
    username,
    names,
    lastnames,
    phone,
    email,
    number_identification,
    type_document,
    id_type_user,
    status,
    email_verified
FROM users.user_restaurant
WHERE status = 1;