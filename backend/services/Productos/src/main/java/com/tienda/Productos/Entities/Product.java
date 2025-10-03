package com.tienda.Productos.Entities;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Product {
    private Integer id;
    private String nombre;
    private BigDecimal precio;
    private BigDecimal costo;
    private Integer stock;
    private String descripcion;
    private String resumen;
    private Integer subCategoriaId;
    private String especificaciones;
    private Integer colorId;
    private Integer statusId;
    private String sku;
    private Map<String, Object> fichaTecnica;
    private Integer marcaId;
    private BigDecimal peso;
    private String dimensiones;
    private Boolean activo;
    private Timestamp createdAt;
    private Timestamp updatedAt;
}