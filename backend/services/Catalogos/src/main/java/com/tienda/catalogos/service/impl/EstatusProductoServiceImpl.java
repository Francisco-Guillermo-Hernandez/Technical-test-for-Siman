package com.tienda.catalogos.service.impl;

import com.tienda.catalogos.entities.EstatusProducto;
import com.tienda.catalogos.repository.EstatusProductoRepository;
import com.tienda.catalogos.service.EstatusProductoService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EstatusProductoServiceImpl implements EstatusProductoService {
    private final EstatusProductoRepository repository;
    public EstatusProductoServiceImpl(EstatusProductoRepository repository) { this.repository = repository; }
    @Override
    public List<EstatusProducto> listAll() { return repository.findAll(); }
}
