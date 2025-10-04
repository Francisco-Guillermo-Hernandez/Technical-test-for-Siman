package com.tienda.catalogos.service.impl;

import com.tienda.catalogos.entities.Color;
import com.tienda.catalogos.repository.ColorRepository;
import com.tienda.catalogos.service.ColorService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ColorServiceImpl implements ColorService {
    private final ColorRepository repository;
    public ColorServiceImpl(ColorRepository repository) { this.repository = repository; }
    @Override
    public List<Color> listAll() { return repository.findAll(); }
}
