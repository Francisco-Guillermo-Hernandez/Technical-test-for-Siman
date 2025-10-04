-- Índices para optimización de consultas

-- Índices para productos
CREATE INDEX idx_productos_sub_categoria ON productos(sub_categoria_id);
CREATE INDEX idx_productos_marca ON productos(marca_id);
CREATE INDEX idx_productos_sku ON productos(sku);
CREATE INDEX idx_productos_activo ON productos(activo);
CREATE INDEX idx_productos_precio ON productos(precio);
CREATE INDEX idx_productos_stock ON productos(stock);
CREATE INDEX idx_productos_created_at ON productos(created_at);

-- Índices para fotografías
CREATE INDEX idx_fotografias_producto ON fotografias(producto_id);
CREATE INDEX idx_fotografias_principal ON fotografias(es_principal);

-- Índices para ventas
CREATE INDEX idx_ventas_cliente ON ventas(cliente_id);
CREATE INDEX idx_ventas_fecha ON ventas(fecha_compra);
CREATE INDEX idx_ventas_estatus ON ventas(estatus);
CREATE INDEX idx_ventas_numero_orden ON ventas(numero_orden);
CREATE INDEX idx_ventas_metodo_pago ON ventas(metodo_pago_id);

-- Índices para artículos comprados
CREATE INDEX idx_articulos_venta ON articulos_comprados(venta_id);
CREATE INDEX idx_articulos_producto ON articulos_comprados(producto_id);

-- Índices para entregas
CREATE INDEX idx_entregas_venta ON entregas(venta_id);
CREATE INDEX idx_entregas_tracking ON entregas(numero_seguimiento);
CREATE INDEX idx_entregas_status ON entregas(tracking_status);

-- Índices para reseñas
CREATE INDEX idx_resenas_producto ON resenas(producto_id);
CREATE INDEX idx_resenas_cliente ON resenas(cliente_id);
CREATE INDEX idx_resenas_calificacion ON resenas(calificacion);

-- Índices para categorías y subcategorías
CREATE INDEX idx_sub_categorias_categoria ON sub_categorias(categoria_id);
CREATE INDEX idx_marcas_categoria ON marcas(categoria_id);

-- Índices para descuentos
CREATE INDEX idx_descuentos_categoria ON descuentos(categoria_id);
CREATE INDEX idx_descuentos_fechas ON descuentos(valido_desde, valido_hasta);
CREATE INDEX idx_descuentos_activo ON descuentos(activo);

-- Índices para usuarios
CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_usuarios_username ON usuarios(username);
CREATE INDEX idx_usuarios_rol ON usuarios(rol);
CREATE INDEX idx_usuarios_activo ON usuarios(activo);

-- Índices para clientes
CREATE INDEX idx_clientes_correo ON clientes(correo);
CREATE INDEX idx_clientes_documento ON clientes(documento_identidad);
CREATE INDEX idx_clientes_activo ON clientes(activo);