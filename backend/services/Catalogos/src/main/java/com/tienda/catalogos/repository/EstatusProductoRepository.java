package com.tienda.catalogos.repository;

import com.tienda.catalogos.entities.EstatusProducto;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EstatusProductoRepository extends JpaRepository<EstatusProducto, Long> {
}
