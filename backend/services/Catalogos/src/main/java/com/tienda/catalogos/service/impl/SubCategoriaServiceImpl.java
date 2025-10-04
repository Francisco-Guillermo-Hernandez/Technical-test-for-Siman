package com.tienda.catalogos.service.impl;

import com.tienda.catalogos.entities.SubCategoria;
import com.tienda.catalogos.repository.SubCategoriaRepository;
import com.tienda.catalogos.service.SubCategoriaService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SubCategoriaServiceImpl implements SubCategoriaService {
    private final SubCategoriaRepository repository;
    public SubCategoriaServiceImpl(SubCategoriaRepository repository) { this.repository = repository; }
    @Override
    public List<SubCategoria> listAll() { return repository.findAll(); }
}
