package com.tienda.catalogos.repository;

import com.tienda.catalogos.entities.Marca;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MarcaRepository extends JpaRepository<Marca, Long> {
}
