--* CREACIÓN DE ESQUEMAS
---------------------------------------------------------------------------------------------------
-- MAESTRO 1 --- JHOAN VICENTE
CREATE SCHEMA users AUTHORIZATION dbo;
GO
-- MAESTRO 2 ---ANGIE CHACON
CREATE SCHEMA product AUTHORIZATION dbo;
GO
--* TRANFERENCIA DE ESQUEMAS
-- MAESTRO 1 --- JHOAN VICENTE
ALTER SCHEMA users TRANSFER dbo.user_restaurant;
GO
ALTER SCHEMA users TRANSFER dbo.type_user;
GO
-- MAESTRO 2 ---ANGIE CHACON
ALTER SCHEMA product TRANSFER dbo.category;
GO
ALTER SCHEMA product TRANSFER dbo.detail_product;
GO
ALTER SCHEMA product TRANSFER dbo.product;
GO
---------------------------------------------------------------------------------------------------

--* ELIMINACIÓN DE ESQUEMAS
DROP SCHEMA users;

--* CONSULTAS DE ESQUEMAS	
-- Ver todos los esquemas en la base de datos
SELECT schema_name FROM information_schema.schemata;
GO
-- Ver las tablas en un esquema específico
SELECT table_name FROM information_schema.tables WHERE table_schema = 'user';