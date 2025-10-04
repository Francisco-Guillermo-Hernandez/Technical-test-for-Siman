
-- -- Insertar métodos de pago
-- INSERT INTO metodos_pago (nombre, descripcion) VALUES
-- ('Credisiman', 'Utiliza nuestra Credisiman'),
-- ('Efectivo', 'Pago en efectivo contra entrega'),
-- ('Tarjeta de Crédito / Débito', 'Pago con tarjeta de crédito'),
-- ('Transferencia Bancaria', 'Transferencia bancaria directa'),
-- ('PayPal', 'Pago a través de PayPal');

-- -- Insertar estatus de producto
-- INSERT INTO estatus_producto (nombre, descripcion) VALUES
-- ('Disponible', 'Producto disponible para venta'),
-- ('Agotado', 'Producto temporalmente agotado'),
-- ('Descontinuado', 'Producto descontinuado'),
-- ('Próximamente', 'Producto próximo a estar disponible'),
-- ('En Reposición', 'Producto en proceso de reposición');

-- -- Insertar colores básicos
-- INSERT INTO colores (nombre, codigo_hex) VALUES
-- ('Negro', '#000000'),
-- ('Blanco', '#FFFFFF'),
-- ('Rojo', '#FF0000'),
-- ('Azul', '#0000FF'),
-- ('Verde', '#008000'),
-- ('Amarillo', '#FFFF00'),
-- ('Naranja', '#FFA500'),
-- ('Rosa', '#FFC0CB'),
-- ('Gris', '#808080'),
-- ('Marrón', '#A52A2A'),
-- ('Violeta', '#8A2BE2'),
-- ('Turquesa', '#40E0D0');

-- -- Insertar categorías principales
-- INSERT INTO categorias (nombre, descripcion) VALUES
-- ('Electrónicos', 'Dispositivos electrónicos y tecnología'),
-- ('Ropa y Accesorios', 'Vestimenta y accesorios de moda'),
-- ('Hogar y Jardín', 'Artículos para el hogar y jardín'),
-- ('Deportes y Recreación', 'Equipos deportivos y recreativos'),
-- ('Libros y Medios', 'Libros, música y medios digitales'),
-- ('Salud y Belleza', 'Productos de salud y cuidado personal'),
-- ('Automóviles', 'Accesorios y repuestos para vehículos'),
-- ('Juguetes y Juegos', 'Juguetes y juegos para todas las edades');

-- -- Insertar subcategorías
-- INSERT INTO sub_categorias (nombre, categoria_id) VALUES
-- -- Electrónicos
-- ('Smartphones', 1),
-- ('Laptops', 1),
-- ('Tablets', 1),
-- ('Auriculares', 1),
-- ('Cámaras', 1),
-- ('Televisores', 1),
-- ('Consolas de Videojuegos', 1),

-- -- Ropa y Accesorios
-- ('Camisetas', 2),
-- ('Pantalones', 2),
-- ('Zapatos', 2),
-- ('Bolsos', 2),
-- ('Relojes', 2),
-- ('Joyería', 2),

-- -- Hogar y Jardín
-- ('Muebles', 3),
-- ('Decoración', 3),
-- ('Electrodomésticos', 3),
-- ('Herramientas de Jardín', 3),
-- ('Iluminación', 3),

-- -- Deportes y Recreación
-- ('Fitness', 4),
-- ('Fútbol', 4),
-- ('Basketball', 4),
-- ('Natación', 4),
-- ('Ciclismo', 4),

-- -- Libros y Medios
-- ('Ficción', 5),
-- ('No Ficción', 5),
-- ('Música', 5),
-- ('Películas', 5),

-- -- Salud y Belleza
-- ('Cuidado de la Piel', 6),
-- ('Maquillaje', 6),
-- ('Suplementos', 6),
-- ('Cuidado del Cabello', 6),

-- -- Automóviles
-- ('Accesorios Interiores', 7),
-- ('Accesorios Exteriores', 7),
-- ('Repuestos', 7),

-- -- Juguetes y Juegos
-- ('Juguetes Educativos', 8),
-- ('Juegos de Mesa', 8),
-- ('Muñecas', 8),
-- ('Vehículos de Juguete', 8);

-- -- Insertar marcas
-- INSERT INTO marcas (nombre, categoria_id, descripcion) VALUES
-- -- Electrónicos
-- ('Apple', 1, 'Productos Apple Inc.'),
-- ('Samsung', 1, 'Productos Samsung Electronics'),
-- ('Sony', 1, 'Productos Sony Corporation'),
-- ('LG', 1, 'Productos LG Electronics'),
-- ('Huawei', 1, 'Productos Huawei Technologies'),

-- -- Ropa y Accesorios
-- ('Nike', 2, 'Marca deportiva Nike'),
-- ('Adidas', 2, 'Marca deportiva Adidas'),
-- ('Zara', 2, 'Marca de moda Zara'),
-- ('H&M', 2, 'Marca de moda H&M'),

-- -- Hogar y Jardín
-- ('IKEA', 3, 'Muebles y decoración IKEA'),
-- ('Philips', 3, 'Electrodomésticos Philips'),

-- -- Deportes
-- ('Wilson', 4, 'Equipos deportivos Wilson'),
-- ('Spalding', 4, 'Equipos deportivos Spalding');

-- -- Insertar usuario administrador por defecto
-- INSERT INTO usuarios (username, email, password_hash, rol) VALUES
-- ('admin', 'admin@tienda.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ADMIN');

-- -- Insertar dirección de ejemplo
-- INSERT INTO direcciones (pais, departamento, provincia, distrito, direccion_completa, codigo_postal) VALUES
-- ('Perú', 'Lima', 'Lima', 'Miraflores', 'Av. Larco 123, Miraflores', '15074');

-- -- Insertar cliente de ejemplo
-- INSERT INTO clientes (nombre, apellido, correo, documento_identidad, direccion_id, genero, telefono) VALUES
-- ('Juan', 'Pérez', 'juan.perez@email.com', '12345678', 1, 'Masculino', '987654321');