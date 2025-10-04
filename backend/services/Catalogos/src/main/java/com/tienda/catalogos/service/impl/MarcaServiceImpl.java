package com.tienda.catalogos.service.impl;

import com.tienda.catalogos.entities.Marca;
import com.tienda.catalogos.repository.MarcaRepository;
import com.tienda.catalogos.service.MarcaService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MarcaServiceImpl implements MarcaService {
    private final MarcaRepository repository;
    public MarcaServiceImpl(MarcaRepository repository) { this.repository = repository; }
    @Override
    public List<Marca> listAll() { return repository.findAll(); }
}
