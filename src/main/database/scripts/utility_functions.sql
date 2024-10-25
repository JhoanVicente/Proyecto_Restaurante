
--* Creación de Indice no clusterizado

--? Consulta de Indices en una tabla específica
        sp_helpindex 'users.user_restaurant';

--? Eiminar un Indice
DROP INDEX users.user_restaurant.IDX_user_restaurant_status;
GO
---------------------------------------------------------------------------------------------------
--? Creación de Indice no clusterizado para la tabla users.user_restaurant
-- 1. Busqueda por estado
CREATE NONCLUSTERED INDEX IDX_user_restaurant_status ON users.user_restaurant(status);
GO
-- 2. Busqueda por nombre
CREATE NONCLUSTERED INDEX IDX_user_restaurant_names ON users.user_restaurant(names);
GO
-- 3. Busqueda por id de usuario
CREATE NONCLUSTERED INDEX IDX_user_restaurant_id_user ON users.user_restaurant(id_user);
GO
--? Creación de Indice no clusterizado para la tabla ticket_sale
-- 1. Busqueda de todos los ticker por su estado
CREATE NONCLUSTERED INDEX IDX_ticket_sale_status ON ticket_sale(id_type_status);
GO
--? Creación de Indice no clusterizado para la tabla product.detail_product
-- 1. Busqueda de todo el detalle de productos por su ticket de venta
CREATE NONCLUSTERED INDEX IDX_detail_product_id_ticket ON product.detail_product(id_ticket);
GO
---------------------------------------------------------------------------------------------------
--* Uso de Estadísticas
-- IO --> Muestra cuántas lecturas lógicas y físicas utiliza SQL Server mientras ejecuta una consulta, Ejemplo: sería el número de páginas que se leen de la memoria caché y el número de páginas que se leen del disco.
SET STATISTICS IO ON;
GO
-- TIME --> Muestra el tiempo que tarda SQL Server en ejecutar una consulta., Ejemplo: CPU time que es el tiempo que tarda el procesador en ejecutar la consulta y el elapsed time que es el tiempo total que tarda en ejecutar la consulta.
SET STATISTICS TIME ON;
GO

--* Uso de Crud para las Tablas

--? Crud para la tabla users.user_restaurant
-- 1. Insertar un nuevo usuario
INSERT INTO users.user_restaurant (username, password, names, lastnames, date_birth, address, phone, email, number_identification, type_document, id_type_user, status) VALUES ('Juan', '21232f297a57a5a743894a0e4a801fc3', 'Juan Leonardo', 'Vicente Cruz', '2000-03-19', 'san vicente de cañete, av mariscal benavides', '979333493', 'juan.leonardo@vallegrande.edu.pe', '72036366', 'DNI', 3, 3);
GO
-- 2. Actualizar un usuario su usuario
UPDATE users.user_restaurant SET username = "Jorge" WHERE id_user = 3;
GO
-- 3. Eliminar un usuario (Físico)
DELETE FROM users.user_restaurant WHERE id_user = 11;
GO
-- 4. Eliminar un usuario (Lógico)
UPDATE users.user_restaurant SET status = 0 WHERE id_user = 11;
GO
-- 5. Consultar todos los usuarios
SELECT * FROM users.user_restaurant;
GO
-- 6. Consultar un usuario por su id
SELECT * FROM users.user_restaurant WHERE id_user = 11;
GO


--* Funciones de Estadísticas

--? Estadísiticas para la venta de tickets
-- 1. Contar el número total de pedidos realizados por un cliente específico
SELECT COUNT(*) AS NumeroPedidos
FROM ticket_sale
WHERE id_user = 3;
GO
-- 2. Obtiener la suma total pagada por un usuario
SELECT SUM(total_pay) AS TotalPagado
FROM ticket_sale
WHERE id_user = 3;
GO
--? Estadísiticas para los productos
-- 1. Obtiene el precio más alto de todos los productos
SELECT MAX(price) AS PrecioMaximo
FROM product;
GO
-- 2. obtiene el precio más bajo de todos los productos
SELECT MIN(price) AS PrecioMinimo
FROM product;
GO