package com.tienda.Productos.Entities;

import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductFilter {
    private String name;
    private Integer categoryId;
    private Integer subCategoryId;
    private Integer brandId;
    private Integer colorId;
    private Integer statusId;
    private BigDecimal minPrice;
    private BigDecimal maxPrice;
    private String stockStatus;
    private Boolean active;

}