--* TIPO DE DATO DE USUARIO EN SQL SERVER
---------------------------------------------------------------------------------------------------

-- MAESTRO 1 --- JHOAN VICENTE
CREATE TYPE name_v FROM VARCHAR(90) NOT NULL;
GO
CREATE TYPE typestatus_i FROM INT NOT NULL;
GO
CREATE TYPE userid_i FROM INT NOT NULL;
GO
CREATE TYPE defaultStatus_b FROM BIT NOT NULL;
GO
-- MAESTRO 2 --- ANGIE CHACON
CREATE TYPE productid_i FROM INT NOT NULL;
GO
CREATE TYPE note_v FROM TEXT NOT NULL;
GO
CREATE TYPE price_d FROM DECIMAL(6,2) NOT NULL;
GO
CREATE TYPE datatime_d FROM DATETIME NOT NULL;
GO
---------------------------------------------------------------------------------------------------
-- Eliminar el tipo de datos existente
DROP TYPE note_v;
GO