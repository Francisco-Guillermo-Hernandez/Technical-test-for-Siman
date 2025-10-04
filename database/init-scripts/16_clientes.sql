SET session_replication_role = 'replica';

TRUNCATE TABLE "clientes" CASCADE;

INSERT INTO "clientes" ("id", "nombre", "apellido", "correo", "documento_identidad", "direccion_id", "genero", "fecha_cumpleanos", "telefono", "activo", "created_at", "updated_at") VALUES
(1, 'Rosaleen', 'Reddoch', 'rosaleen.reddoch@aliceadsl.fr', '123456790', '88', 'otro', '2006-01-17', '(919) 123-7645', '0', '2024-09-26 15:53:43', '2024-09-29 08:16:34');

