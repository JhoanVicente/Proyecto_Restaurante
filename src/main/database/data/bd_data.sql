--* Datos para la base de datos

--  datos de la tabla type_user
INSERT INTO users.type_user (name) VALUES('administrador'),
                                         ('mesero'),
                                         ('cliente');
GO
-- datos de la tabla user_restaurant
INSERT INTO users.user_restaurant (username, password, names, lastnames, date_birth, address, phone, email, number_identification, type_document, id_type_user, status, email_verified) VALUES
    ('Jhoan', '21232f297a57a5a743894a0e4a801fc3', 'Jhoan Daniel', 'Vicente Cruz', '2006-03-06', 'san vicente de cañete, av 28 de Julio', '973182822', 'jhoan.vicente@vallegrande.edu.pe', '75198234', 'DNI', 1, 1,1),
    ('Angie', '21232f297a57a5a743894a0e4a801fc3', 'Angie Derlyn', 'Chacon Aparcana', '2000-05-10', 'imperial cañete, av 28 de julio', '950263442', 'angie.chacon@vallegrande.edu.pe', '73948281', 'DNI', 1, 1,1),
    ('Jorge', '21232f297a57a5a743894a0e4a801fc3', 'Jorge Luis', 'Gonzales Rivera', '2005-05-10', 'calle a', '988354321', 'jorge@vallegrande.edu.pe', '73948200', 'DNI', 2, 1,1),
    ('Maria', '21232f297a57a5a743894a0e4a801fc3', 'Maria luisa', 'Lopez Salvador', '2000-01-01', 'calle b', '988354322', 'maria@vallegrande.edu.pe', '73948201', 'DNI', 3, 1,1),
    ('Pedro', '21232f297a57a5a743894a0e4a801fc3', 'Juan Pedro', 'Ramirez Saldo', '2000-01-01', 'calle c', '988354323', 'pedro@vallegrande.edu.pe', '73948202', 'DNI', 3, 1,1),
    ('Laura', '21232f297a57a5a743894a0e4a801fc3', 'Laura Amara', 'Martinez Dammer', '2000-01-01', 'calle d', '988354324', 'laura@vallegrande.edu.pe', '73948203', 'DNI', 2, 1,1),
    ('Carlos', '21232f297a57a5a743894a0e4a801fc3', 'Carlos Mateo', 'Perez Rodriguez', '2000-01-01', 'calle e', '988354325', 'carlos@vallegrande.edu.pe', '73948204', 'DNI', 2, 1,1),
    ('Luis', '21232f297a57a5a743894a0e4a801fc3', 'Luis Alejandro', 'Gutierrez Sanchez', '2000-01-01', 'calle f', '988354326', 'luis@vallegrande.edu.pe', '73948205', 'DNI', 3, 1,1),
    ('Ana', '21232f297a57a5a743894a0e4a801fc3', 'Ana Camila', 'Sanchez Londra', '2000-01-01', 'calle g', '988354327', 'ana@vallegrande.edu.pe', '73948206', 'DNI', 3, 1,1),
    ('Sara', '21232f297a57a5a743894a0e4a801fc3', 'Sara Andrea', 'Diaz Yankee', '2000-01-01', 'calle h', '988354328', 'sara@vallegrande.edu.pe', '73948207', 'DNI', 1, 1,1);

-- datos de la tabla type_status_order
INSERT INTO type_status_order (name) VALUES('Pendiente'),
                                           ('Aceptado'),
                                           ('Rechazado'),
                                           ('Completado');
GO
-- datos de la tabla type_payment
INSERT INTO type_payment (name) VALUES('Efectivo'), 
                                    ('Yape'),
                                    ('Tarjeta');
GO

-- datos de la tabla category
INSERT INTO product.category (name) VALUES('Menu'),
                                        ('Bebida'),
                                        ('Marino');
GO

-- datos de la tabla product
INSERT INTO product.product (id_category, image, name, note, price, date_p, id_user, status) VALUES
    (3, '09062024040840-120458549634166763ceviche.jpg', 'Ceviche Clásico', 'pesca del día en leche de tigre clásica, entre más cosas', 19.00, '2024-06-09 04:08:40.073', 1, 1),
    (3, '09062024020233490491006402809600sudadodePescado.jpg', 'Sudado de pescado', 'El riquísimo sudado de pescado peruano es muy conocido.', 25.00, '2024-06-09 14:02:33.510', 1, 1),
    (3, '09062024020637-8713321124620264749truchaFrita.jpg', 'Trucha Frita', 'La trucha frita es un plato que se ha vuelto típico de la gastronomía peruana', 25.00, '2024-06-09 14:06:37.700', 1, 1),
    (1, '090620240211331717176451597982952tallarinesVerdes.jpg', 'Tallarines Verdes', 'Los Tallarines Verdes, un plato muy delicioso para el', 15.00, '2024-06-09 14:11:33.793', 1, 1),
    (1, '09062024021601-1866357301907864302pollobrasau14.jpg', '1/4 Brasa con Papas y ensalada', 'Pollo a la brasa es la denominación que se da en el Perú al pollo asado-', 29.90, '2024-06-09 14:16:01.803', 1, 1),
    (2, '09062024022006-2282143402743148797geseosaIncaKola.jpg', 'Gaseosa INCA KOLA Botella 600ml', 'Bebida saborizada dulce, Conservar en lugar fresco y seguro, Revisar componentes asociados al azúcar', 3.00, '2024-06-09 14:20:06.720', 1, 1),
    (2, '09062024022229-5162791127941430194cocakola.jpg', 'Gaseosa COCA COLA Original (600 ml)', 'Bebida saborizada dulce, Conservar en lugar fresco y seguro, Revisar componentes asociados al azúcar', 3.00, '2024-06-09 14:22:29.457', 1, 1),
    (1, '09062024023749-1522774370971890074lomosaltado.jpg', 'Lomo saltado', 'El lomo saltado ya aparece en recetarios peruanos en 1903', 15.00, '2024-06-09 14:37:49.897', 1, 1);