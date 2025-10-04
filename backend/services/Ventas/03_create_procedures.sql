-- Procedimientos almacenados para el sistema de tienda

-- Procedimiento para crear un producto
CREATE OR REPLACE FUNCTION sp_crear_producto(
    p_nombre VARCHAR(200),
    p_precio DECIMAL(10,2),
    p_costo DECIMAL(10,2),
    p_stock INTEGER,
    p_descripcion TEXT,
    p_resumen VARCHAR(500),
    p_sub_categoria_id INTEGER,
    p_especificaciones TEXT,
    p_color_id INTEGER,
    p_status_id INTEGER,
    p_sku VARCHAR(100),
    p_ficha_tecnica JSONB,
    p_marca_id INTEGER,
    p_peso DECIMAL(8,3),
    p_dimensiones VARCHAR(100)
) RETURNS INTEGER AS $$
DECLARE
    nuevo_id INTEGER;
BEGIN
    INSERT INTO productos (
        nombre, precio, costo, stock, descripcion, resumen,
        sub_categoria_id, especificaciones, color_id, status_id,
        sku, ficha_tecnica, marca_id, peso, dimensiones
    ) VALUES (
        p_nombre, p_precio, p_costo, p_stock, p_descripcion, p_resumen,
        p_sub_categoria_id, p_especificaciones, p_color_id, p_status_id,
        p_sku, p_ficha_tecnica, p_marca_id, p_peso, p_dimensiones
    ) RETURNING id INTO nuevo_id;
    
    RETURN nuevo_id;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para actualizar stock de producto
CREATE OR REPLACE FUNCTION sp_actualizar_stock(
    p_producto_id INTEGER,
    p_cantidad INTEGER,
    p_operacion VARCHAR(10) -- 'suma' o 'resta'
) RETURNS BOOLEAN AS $$
DECLARE
    stock_actual INTEGER;
    nuevo_stock INTEGER;
BEGIN
    -- Obtener stock actual
    SELECT stock INTO stock_actual FROM productos WHERE id = p_producto_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Producto no encontrado con ID: %', p_producto_id;
    END IF;
    
    -- Calcular nuevo stock
    IF p_operacion = 'suma' THEN
        nuevo_stock := stock_actual + p_cantidad;
    ELSIF p_operacion = 'resta' THEN
        nuevo_stock := stock_actual - p_cantidad;
        IF nuevo_stock < 0 THEN
            RAISE EXCEPTION 'Stock insuficiente. Stock actual: %, Cantidad solicitada: %', stock_actual, p_cantidad;
        END IF;
    ELSE
        RAISE EXCEPTION 'Operación no válida: %. Use "suma" o "resta"', p_operacion;
    END IF;
    
    -- Actualizar stock
    UPDATE productos 
    SET stock = nuevo_stock, updated_at = CURRENT_TIMESTAMP 
    WHERE id = p_producto_id;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para crear una venta completa
CREATE OR REPLACE FUNCTION sp_crear_venta(
    p_cliente_id INTEGER,
    p_metodo_pago_id INTEGER,
    p_productos JSONB -- Array de objetos {producto_id, cantidad, precio_unitario}
) RETURNS INTEGER AS $$
DECLARE
    nueva_venta_id INTEGER;
    numero_orden_generado VARCHAR(50);
    producto_item JSONB;
    subtotal_venta DECIMAL(12,2) := 0;
    total_venta DECIMAL(12,2) := 0;
    stock_disponible INTEGER;
BEGIN
    -- Generar número de orden único
    numero_orden_generado := 'ORD-' || TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD') || '-' || LPAD(nextval('ventas_id_seq')::TEXT, 6, '0');
    
    -- Validar stock para todos los productos antes de procesar
    FOR producto_item IN SELECT * FROM jsonb_array_elements(p_productos)
    LOOP
        SELECT stock INTO stock_disponible 
        FROM productos 
        WHERE id = (producto_item->>'producto_id')::INTEGER AND activo = true;
        
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Producto no encontrado o inactivo: %', producto_item->>'producto_id';
        END IF;
        
        IF stock_disponible < (producto_item->>'cantidad')::INTEGER THEN
            RAISE EXCEPTION 'Stock insuficiente para producto ID %. Stock disponible: %, Cantidad solicitada: %', 
                producto_item->>'producto_id', stock_disponible, producto_item->>'cantidad';
        END IF;
        
        subtotal_venta := subtotal_venta + ((producto_item->>'cantidad')::INTEGER * (producto_item->>'precio_unitario')::DECIMAL(10,2));
    END LOOP;
    
    total_venta := subtotal_venta; -- Por ahora sin impuestos ni descuentos
    
    -- Crear la venta
    INSERT INTO ventas (cliente_id, subtotal, total, metodo_pago_id, numero_orden, estatus)
    VALUES (p_cliente_id, subtotal_venta, total_venta, p_metodo_pago_id, numero_orden_generado, 'pendiente')
    RETURNING id INTO nueva_venta_id;
    
    -- Insertar artículos comprados y actualizar stock
    FOR producto_item IN SELECT * FROM jsonb_array_elements(p_productos)
    LOOP
        -- Insertar artículo comprado
        INSERT INTO articulos_comprados (venta_id, producto_id, cantidad, precio_unitario, subtotal)
        VALUES (
            nueva_venta_id,
            (producto_item->>'producto_id')::INTEGER,
            (producto_item->>'cantidad')::INTEGER,
            (producto_item->>'precio_unitario')::DECIMAL(10,2),
            (producto_item->>'cantidad')::INTEGER * (producto_item->>'precio_unitario')::DECIMAL(10,2)
        );
        
        -- Actualizar stock
        PERFORM sp_actualizar_stock(
            (producto_item->>'producto_id')::INTEGER,
            (producto_item->>'cantidad')::INTEGER,
            'resta'
        );
    END LOOP;
    
    RETURN nueva_venta_id;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para actualizar estatus de venta
CREATE OR REPLACE FUNCTION sp_actualizar_estatus_venta(
    p_venta_id INTEGER,
    p_nuevo_estatus VARCHAR(20),
    p_notas TEXT DEFAULT NULL
) RETURNS BOOLEAN AS $$
DECLARE
    estatus_actual VARCHAR(20);
BEGIN
    -- Obtener estatus actual
    SELECT estatus INTO estatus_actual FROM ventas WHERE id = p_venta_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Venta no encontrada con ID: %', p_venta_id;
    END IF;
    
    -- Validar transiciones de estado permitidas
    IF estatus_actual = 'cancelado' OR estatus_actual = 'entregado' THEN
        RAISE EXCEPTION 'No se puede cambiar el estatus de una venta % o %', 'cancelado', 'entregado';
    END IF;
    
    -- Actualizar estatus
    UPDATE ventas 
    SET estatus = p_nuevo_estatus,
        fecha_actualizacion = CURRENT_TIMESTAMP,
        notas = COALESCE(p_notas, notas),
        fecha_confirmacion = CASE WHEN p_nuevo_estatus = 'confirmado' THEN CURRENT_TIMESTAMP ELSE fecha_confirmacion END,
        fecha_envio = CASE WHEN p_nuevo_estatus = 'enviado' THEN CURRENT_TIMESTAMP ELSE fecha_envio END
    WHERE id = p_venta_id;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para obtener productos con filtros y paginación
CREATE OR REPLACE FUNCTION sp_buscar_productos(
    p_categoria_id INTEGER DEFAULT NULL,
    p_marca_id INTEGER DEFAULT NULL,
    p_precio_min DECIMAL(10,2) DEFAULT NULL,
    p_precio_max DECIMAL(10,2) DEFAULT NULL,
    p_busqueda TEXT DEFAULT NULL,
    p_page INTEGER DEFAULT 0,
    p_size INTEGER DEFAULT 20
) RETURNS TABLE (
    id INTEGER,
    nombre VARCHAR(200),
    precio DECIMAL(10,2),
    stock INTEGER,
    sku VARCHAR(100),
    categoria_nombre VARCHAR(100),
    marca_nombre VARCHAR(100),
    imagen_principal VARCHAR(500),
    total_count BIGINT
) AS $$
BEGIN
    RETURN QUERY
    WITH productos_filtrados AS (
        SELECT p.id, p.nombre, p.precio, p.stock, p.sku,
               c.nombre as categoria_nombre,
               m.nombre as marca_nombre,
               f.url as imagen_principal,
               COUNT(*) OVER() as total_count
        FROM productos p
        LEFT JOIN sub_categorias sc ON p.sub_categoria_id = sc.id
        LEFT JOIN categorias c ON sc.categoria_id = c.id
        LEFT JOIN marcas m ON p.marca_id = m.id
        LEFT JOIN fotografias f ON p.id = f.producto_id AND f.es_principal = true
        WHERE p.activo = true
          AND (p_categoria_id IS NULL OR c.id = p_categoria_id)
          AND (p_marca_id IS NULL OR p.marca_id = p_marca_id)
          AND (p_precio_min IS NULL OR p.precio >= p_precio_min)
          AND (p_precio_max IS NULL OR p.precio <= p_precio_max)
          AND (p_busqueda IS NULL OR p.nombre ILIKE '%' || p_busqueda || '%')
        ORDER BY p.created_at DESC
        LIMIT p_size OFFSET (p_page * p_size)
    )
    SELECT * FROM productos_filtrados;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para crear entrega
CREATE OR REPLACE FUNCTION sp_crear_entrega(
    p_venta_id INTEGER,
    p_fecha_estimada DATE,
    p_numero_seguimiento VARCHAR(100)
) RETURNS INTEGER AS $$
DECLARE
    nueva_entrega_id INTEGER;
BEGIN
    INSERT INTO entregas (venta_id, fecha_estimada_entrega, numero_seguimiento)
    VALUES (p_venta_id, p_fecha_estimada, p_numero_seguimiento)
    RETURNING id INTO nueva_entrega_id;
    
    RETURN nueva_entrega_id;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para actualizar tracking de entrega
CREATE OR REPLACE FUNCTION sp_actualizar_tracking_entrega(
    p_entrega_id INTEGER,
    p_nuevo_status VARCHAR(20),
    p_repartidor_nombre VARCHAR(100) DEFAULT NULL,
    p_repartidor_telefono VARCHAR(20) DEFAULT NULL,
    p_comentarios TEXT DEFAULT NULL
) RETURNS BOOLEAN AS $$
BEGIN
    UPDATE entregas 
    SET tracking_status = p_nuevo_status,
        updated_at = CURRENT_TIMESTAMP,
        repartidor_nombre = COALESCE(p_repartidor_nombre, repartidor_nombre),
        repartidor_telefono = COALESCE(p_repartidor_telefono, repartidor_telefono),
        comentarios = COALESCE(p_comentarios, comentarios),
        fecha_entrega = CASE WHEN p_nuevo_status = 'entregado' THEN CURRENT_TIMESTAMP ELSE fecha_entrega END
    WHERE id = p_entrega_id;
    
    -- Si se marca como entregado, actualizar también la venta
    IF p_nuevo_status = 'entregado' THEN
        UPDATE ventas 
        SET estatus = 'entregado', fecha_actualizacion = CURRENT_TIMESTAMP
        WHERE id = (SELECT venta_id FROM entregas WHERE id = p_entrega_id);
    END IF;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener reporte de ventas
CREATE OR REPLACE FUNCTION sp_reporte_ventas(
    p_fecha_inicio DATE,
    p_fecha_fin DATE
) RETURNS TABLE (
    fecha DATE,
    total_ventas BIGINT,
    monto_total DECIMAL(12,2),
    productos_vendidos BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.fecha_compra::DATE as fecha,
        COUNT(v.id) as total_ventas,
        SUM(v.total) as monto_total,
        SUM(ac.cantidad) as productos_vendidos
    FROM ventas v
    LEFT JOIN articulos_comprados ac ON v.id = ac.venta_id
    WHERE v.fecha_compra::DATE BETWEEN p_fecha_inicio AND p_fecha_fin
      AND v.estatus != 'cancelado'
    GROUP BY v.fecha_compra::DATE
    ORDER BY fecha DESC;
END;
$$ LANGUAGE plpgsql;