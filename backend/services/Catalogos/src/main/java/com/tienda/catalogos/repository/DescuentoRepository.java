package com.tienda.catalogos.repository;

import com.tienda.catalogos.entities.Descuento;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DescuentoRepository extends JpaRepository<Descuento, Long> {
}
