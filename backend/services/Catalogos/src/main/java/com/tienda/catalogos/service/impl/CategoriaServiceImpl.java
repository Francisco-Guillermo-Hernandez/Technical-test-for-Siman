package com.tienda.catalogos.service.impl;

import com.tienda.catalogos.entities.Categoria;
import com.tienda.catalogos.repository.CategoriaRepository;
import com.tienda.catalogos.service.CategoriaService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoriaServiceImpl implements CategoriaService {

    private final CategoriaRepository categoriaRepository;

    public CategoriaServiceImpl(CategoriaRepository categoriaRepository) {
        this.categoriaRepository = categoriaRepository;
    }

    @Override
    public List<Categoria> listAll() {
        return categoriaRepository.findAll();
    }
}
