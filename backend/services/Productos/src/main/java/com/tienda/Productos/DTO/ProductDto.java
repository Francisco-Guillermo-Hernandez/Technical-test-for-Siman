package com.tienda.Productos.DTO;

import jakarta.persistence.*;

import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Map;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class ProductDto {
    
    
    @NotBlank(message = "El Nombre es requerido")
    @Size(max = 60, message = " El nombre debe de tener menos de 60 caracteres ")
    private String nombre;
    
    @NotNull(message = "El precio es requerido Precio")
    @DecimalMin(value = "0.01", message = "El precio debe de ser mayour a 0")
    @Digits(integer = 10, fraction = 2, message = "Precio debe de contener numeros y decimales")
    private BigDecimal precio;
    
    @NotNull(message = "El costo es requerido Costo")
    @DecimalMin(value = "0.01", message = "El costo debe de ser mayour a 0")
    @Digits(integer = 10, fraction = 2, message = "El costo debe de contener cifras ")
    private BigDecimal costo;
    
    @NotNull(message = "El Stock es requerido")
    @Min(value = 0, message = "El Stock debe de ser mayour a 0")
    private Integer stock;
    
    @Size(max = 250, message = "El Resumen debe de contener menos de 250 caracteres.")
    private String resumen;

    @Size(max = 250, message = "El Resumen debe de contener menos de 250 caracteres.")
    private String descripcion;
    
    private Integer subCategoriaId;
    
    private Integer colorId;
    
    private Integer statusId;
    
    @NotBlank(message = "SKU is required")
    @Size(max = 100, message = "SKU debe de contener menos de 100 caracteres.")
    @Pattern(regexp = "^[a-zA-Z0-9\\-_]+$", message = "SKU puede contener")
    private String sku;
    
    private Map<String, Object> fichaTecnica;
    
    private Integer marcaId;
    
    @DecimalMin(value = "0.001", message = "El peso debe de ser mayour a 0")
    @Digits(integer = 8, fraction = 3, message = "Peso ...")
    private BigDecimal peso;
    
    @Size(max = 70, message = "Las dimensiones deben de contener menos de 70 caracteres ")
    private String dimensiones;
    
    private Boolean activo;
    
    private Timestamp createdAt;
    
    private Timestamp updatedAt;


}
