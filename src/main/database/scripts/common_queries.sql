-- * Proceso Almacenado para gestión del Adminsitrador

-- visualizar todas las ventas de un día en específico
SELECT
    CONVERT(date, ts.date_time) as 'Fecha de la venta',
        ts.id_ticket as 'Número de ticket',
        ts.total_pay as 'Total de pago',
        u.username as 'Usuario que pagó',
        u.names as 'Nombre del usuario',
        CASE
            WHEN ts.is_delivery = 1 THEN 'Entrega a domicilio'
            ELSE 'Entrega en el Restaurante'
            END as 'Método de entrega',
        tp.name as 'Tipo de pago'
FROM
    ticket_sale ts
        JOIN
    users.user_restaurant u ON ts.id_user = u.id_user
        JOIN
    type_payment tp ON ts.id_type_payment = tp.id_type_payment
WHERE
    CONVERT(date, ts.date_time) = '2024-05-31' -- reemplaza con la fecha deseada
  AND ts.id_type_status = 4;
GO