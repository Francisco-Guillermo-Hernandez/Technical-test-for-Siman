package com.tienda.catalogos.controller;

import com.tienda.catalogos.entities.Descuento;
import com.tienda.catalogos.service.DescuentoService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/catalogos/descuentos")
public class DescuentosController {
    private final DescuentoService service;
    public DescuentosController(DescuentoService service) { this.service = service; }
    @GetMapping
    public List<Descuento> list() { return service.listAll(); }
}
