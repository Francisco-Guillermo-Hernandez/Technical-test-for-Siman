package com.tienda.catalogos.repository;

import com.tienda.catalogos.entities.Color;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ColorRepository extends JpaRepository<Color, Long> {
}
