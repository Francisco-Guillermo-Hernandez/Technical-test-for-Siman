package com.tienda.catalogos.service.impl;

import com.tienda.catalogos.entities.Descuento;
import com.tienda.catalogos.repository.DescuentoRepository;
import com.tienda.catalogos.service.DescuentoService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DescuentoServiceImpl implements DescuentoService {
    private final DescuentoRepository repository;
    public DescuentoServiceImpl(DescuentoRepository repository) { this.repository = repository; }
    @Override
    public List<Descuento> listAll() { return repository.findAll(); }
}
