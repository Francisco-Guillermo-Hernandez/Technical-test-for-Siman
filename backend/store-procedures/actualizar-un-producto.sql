



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
