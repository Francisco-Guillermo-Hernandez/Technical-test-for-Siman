package com.tienda.Productos.Mapper;

import org.mapstruct.Mapper;

import com.tienda.Productos.Entities.Product;
import com.tienda.Productos.DTO.ProductDto;

@Mapper(componentModel = "spring")
public interface ProductMapper {

	@org.mapstruct.Mapping(target = "id", ignore = true)
	@org.mapstruct.Mapping(target = "especificaciones", ignore = true)
	Product toEntity(ProductDto dto);

	ProductDto toDto(Product entity);

}