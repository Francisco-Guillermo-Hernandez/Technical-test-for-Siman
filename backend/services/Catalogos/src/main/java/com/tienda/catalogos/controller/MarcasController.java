package com.tienda.catalogos.controller;

import com.tienda.catalogos.entities.Marca;
import com.tienda.catalogos.service.MarcaService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/catalogos/marcas")
public class MarcasController {
    private final MarcaService service;
    public MarcasController(MarcaService service) { this.service = service; }
    @GetMapping
    public List<Marca> list() { return service.listAll(); }
}
