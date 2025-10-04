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



-- Procedimiento para actualizar un producto
CREATE OR REPLACE FUNCTION sp_actualizar_producto(
    p_id INTEGER,
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
) RETURNS BOOLEAN AS $$
BEGIN
    UPDATE productos 
    SET 
        nombre = COALESCE(p_nombre, nombre),
        precio = COALESCE(p_precio, precio),
        costo = COALESCE(p_costo, costo),
        stock = COALESCE(p_stock, stock),
        descripcion = COALESCE(p_descripcion, descripcion),
        resumen = COALESCE(p_resumen, resumen),
        sub_categoria_id = COALESCE(p_sub_categoria_id, sub_categoria_id),
        especificaciones = COALESCE(p_especificaciones, especificaciones),
        color_id = COALESCE(p_color_id, color_id),
        status_id = COALESCE(p_status_id, status_id),
        sku = COALESCE(p_sku, sku),
        ficha_tecnica = COALESCE(p_ficha_tecnica, ficha_tecnica),
        marca_id = COALESCE(p_marca_id, marca_id),
        peso = COALESCE(p_peso, peso),
        dimensiones = COALESCE(p_dimensiones, dimensiones),
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;
    
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;






-- Procedimiento para filtrar productos por rangos de precio y estado del stock
CREATE OR REPLACE FUNCTION sp_filtrar_productos_avanzado(
    p_nombre VARCHAR(200) DEFAULT NULL,
    p_categoria_id INTEGER DEFAULT NULL,
    p_subcategoria_id INTEGER DEFAULT NULL,
    p_marca_id INTEGER DEFAULT NULL,
    p_color_id INTEGER DEFAULT NULL,
    p_status_id INTEGER DEFAULT NULL,
    p_precio_min DECIMAL(10,2) DEFAULT NULL,
    p_precio_max DECIMAL(10,2) DEFAULT NULL,
    p_stock_status VARCHAR(20) DEFAULT NULL, -- 'sin_stock', 'bajo_stock', 'disponible'
    p_activo BOOLEAN DEFAULT NULL,
    p_limit INTEGER DEFAULT 50,
    p_offset INTEGER DEFAULT 0
) RETURNS TABLE(
    id INTEGER,
    nombre VARCHAR(200),
    precio DECIMAL(10,2),
    costo DECIMAL(10,2),
    stock INTEGER,
    descripcion TEXT,
    resumen VARCHAR(500),
    sub_categoria_id INTEGER,
    especificaciones TEXT,
    color_id INTEGER,
    status_id INTEGER,
    sku VARCHAR(100),
    ficha_tecnica JSONB,
    marca_id INTEGER,
    peso DECIMAL(8,3),
    dimensiones VARCHAR(100),
    activo BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    sub_categoria_nombre VARCHAR(100),
    categoria_nombre VARCHAR(100),
    marca_nombre VARCHAR(100),
    color_nombre VARCHAR(50),
    status_nombre VARCHAR(50),
    stock_status VARCHAR(20)
) AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        p.id,
        p.nombre,
        p.precio,
        p.costo,
        p.stock,
        p.descripcion,
        p.resumen,
        p.sub_categoria_id,
        p.especificaciones,
        p.color_id,
        p.status_id,
        p.sku,
        p.ficha_tecnica,
        p.marca_id,
        p.peso,
        p.dimensiones,
        p.activo,
        p.created_at,
        p.updated_at,
        sc.nombre as sub_categoria_nombre,
        c.nombre as categoria_nombre,
        m.nombre as marca_nombre,
        cl.nombre as color_nombre,
        ep.nombre as status_nombre,
        CASE 
            WHEN p.stock = 0 THEN 'sin_stock'
            WHEN p.stock < 5 THEN 'bajo_stock'
            ELSE 'disponible'
        END as stock_status
    FROM productos p
    LEFT JOIN sub_categorias sc ON p.sub_categoria_id = sc.id
    LEFT JOIN categorias c ON sc.categoria_id = c.id
    LEFT JOIN marcas m ON p.marca_id = m.id
    LEFT JOIN colores cl ON p.color_id = cl.id
    LEFT JOIN estatus_producto ep ON p.status_id = ep.id
    WHERE 
        (p_nombre IS NULL OR p.nombre ILIKE '%' || p_nombre || '%')
        AND (p_categoria_id IS NULL OR sc.categoria_id = p_categoria_id)
        AND (p_subcategoria_id IS NULL OR p.sub_categoria_id = p_subcategoria_id)
        AND (p_marca_id IS NULL OR p.marca_id = p_marca_id)
        AND (p_color_id IS NULL OR p.color_id = p_color_id)
        AND (p_status_id IS NULL OR p.status_id = p_status_id)
        AND (p_precio_min IS NULL OR p.precio >= p_precio_min)
        AND (p_precio_max IS NULL OR p.precio <= p_precio_max)
        AND (
            p_stock_status IS NULL 
            OR (
                (p_stock_status = 'sin_stock' AND p.stock = 0)
                OR (p_stock_status = 'bajo_stock' AND p.stock > 0 AND p.stock < 5)
                OR (p_stock_status = 'disponible' AND p.stock >= 5)
            )
        )
        AND (p_activo IS NULL OR p.activo = p_activo)
    ORDER BY p.created_at DESC
    LIMIT p_limit OFFSET p_offset;
END;
$$ LANGUAGE plpgsql;








-- Procedimiento para filtrar productos con múltiples criterios
CREATE OR REPLACE FUNCTION sp_filtrar_productos(
    p_nombre VARCHAR(200) DEFAULT NULL,
    p_categoria_id INTEGER DEFAULT NULL,
    p_subcategoria_id INTEGER DEFAULT NULL,
    p_marca_id INTEGER DEFAULT NULL,
    p_color_id INTEGER DEFAULT NULL,
    p_status_id INTEGER DEFAULT NULL,
    p_precio_min DECIMAL(10,2) DEFAULT NULL,
    p_precio_max DECIMAL(10,2) DEFAULT NULL,
    p_stock_min INTEGER DEFAULT NULL,
    p_stock_max INTEGER DEFAULT NULL,
    p_activo BOOLEAN DEFAULT TRUE,
    p_pagina INTEGER DEFAULT 1,
    p_tamano_pagina INTEGER DEFAULT 10
) RETURNS TABLE(
    id INTEGER,
    nombre VARCHAR(200),
    precio DECIMAL(10,2),
    costo DECIMAL(10,2),
    stock INTEGER,
    descripcion TEXT,
    resumen VARCHAR(500),
    sub_categoria_id INTEGER,
    especificaciones TEXT,
    color_id INTEGER,
    status_id INTEGER,
    sku VARCHAR(100),
    ficha_tecnica JSONB,
    marca_id INTEGER,
    peso DECIMAL(8,3),
    dimensiones VARCHAR(100),
    activo BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        p.id,
        p.nombre,
        p.precio,
        p.costo,
        p.stock,
        p.descripcion,
        p.resumen,
        p.sub_categoria_id,
        p.especificaciones,
        p.color_id,
        p.status_id,
        p.sku,
        p.ficha_tecnica,
        p.marca_id,
        p.peso,
        p.dimensiones,
        p.activo,
        p.created_at,
        p.updated_at
    FROM productos p
    LEFT JOIN sub_categorias sc ON p.sub_categoria_id = sc.id
    LEFT JOIN categorias c ON sc.categoria_id = c.id
    LEFT JOIN marcas m ON p.marca_id = m.id
    LEFT JOIN colores co ON p.color_id = co.id
    LEFT JOIN estatus_producto ep ON p.status_id = ep.id
    WHERE 
        (p_nombre IS NULL OR p.nombre ILIKE '%' || p_nombre || '%')
        AND (p_categoria_id IS NULL OR sc.categoria_id = p_categoria_id)
        AND (p_subcategoria_id IS NULL OR p.sub_categoria_id = p_subcategoria_id)
        AND (p_marca_id IS NULL OR p.marca_id = p_marca_id)
        AND (p_color_id IS NULL OR p.color_id = p_color_id)
        AND (p_status_id IS NULL OR p.status_id = p_status_id)
        AND (p_precio_min IS NULL OR p.precio >= p_precio_min)
        AND (p_precio_max IS NULL OR p.precio <= p_precio_max)
        AND (p_stock_min IS NULL OR p.stock >= p_stock_min)
        AND (p_stock_max IS NULL OR p.stock <= p_stock_max)
        AND (p.activo = p_activo OR p_activo IS NULL)
    ORDER BY p.created_at DESC
    LIMIT p_tamano_pagina OFFSET (p_pagina - 1) * p_tamano_pagina;
END;
$$ LANGUAGE plpgsql;



----

CREATE OR REPLACE FUNCTION fn_productos_paginados(
    p_pagina INTEGER DEFAULT 1,
    p_tamano_pagina INTEGER DEFAULT 10
)
RETURNS TABLE(
    producto_id INTEGER,
    producto_nombre VARCHAR(200),
    precio DECIMAL(10,2),
    costo DECIMAL(10,2),
    stock INTEGER,
    descripcion TEXT,
    resumen VARCHAR(500),
    sku VARCHAR(100),
    ficha_tecnica JSONB,
    peso DECIMAL(8,3),
    dimensiones VARCHAR(100),
    producto_activo BOOLEAN,
    producto_creado TIMESTAMP,
    producto_actualizado TIMESTAMP,
    subcategoria_id INTEGER,
    subCategoria VARCHAR(100),
    categoria_id INTEGER,
    categoria VARCHAR(100),
    marca_nombre VARCHAR(100),
    color_id INTEGER,
    color_nombre VARCHAR(50),
    codigo_hex VARCHAR(7),
    estatus_id INTEGER,
    estatus_ VARCHAR(50),
    foto_principal_url VARCHAR(500),
    foto_principal_alt VARCHAR(200),
    foto_principal_miniatura VARCHAR(500)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_offset INTEGER;
BEGIN
    v_offset := (p_pagina - 1) * p_tamano_pagina;
    
    RETURN QUERY
    SELECT 
        p.id,
        p.nombre,
        p.precio,
        p.costo,
        p.stock,
        p.descripcion,
        p.resumen,
        p.sku,
        p.ficha_tecnica,
        p.peso,
        p.dimensiones,
        p.activo,
        p.created_at,
        p.updated_at,
        
        sc.id,
        sc.nombre,
        
        c.id,
        c.nombre,
        
        m.nombre,
        
        co.id,
        co.nombre,
        co.codigo_hex,
        
        ep.id,
        ep.nombre,
        
        f.url,
        f.alt_text,
        f.miniatura_url
        
    FROM productos p
    LEFT JOIN sub_categorias sc ON p.sub_categoria_id = sc.id
    LEFT JOIN categorias c ON sc.categoria_id = c.id
    LEFT JOIN marcas m ON p.marca_id = m.id
    LEFT JOIN colores co ON p.color_id = co.id
    LEFT JOIN estatus_producto ep ON p.status_id = ep.id
    LEFT JOIN fotografias f ON p.id = f.producto_id AND f.es_principal = true

    WHERE p.activo = true 
    ORDER BY p.created_at DESC 
    LIMIT p_tamano_pagina OFFSET v_offset;
END;
$$;
