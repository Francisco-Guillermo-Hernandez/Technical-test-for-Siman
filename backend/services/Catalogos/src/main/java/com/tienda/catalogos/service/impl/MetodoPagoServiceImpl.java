package com.tienda.catalogos.service.impl;

import com.tienda.catalogos.entities.MetodoPago;
import com.tienda.catalogos.repository.MetodoPagoRepository;
import com.tienda.catalogos.service.MetodoPagoService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MetodoPagoServiceImpl implements MetodoPagoService {
    private final MetodoPagoRepository repository;
    public MetodoPagoServiceImpl(MetodoPagoRepository repository) { this.repository = repository; }
    @Override
    public List<MetodoPago> listAll() { return repository.findAll(); }
}
