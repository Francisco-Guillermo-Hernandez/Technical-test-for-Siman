package com.tienda.catalogos.controller;

import com.tienda.catalogos.entities.SubCategoria;
import com.tienda.catalogos.service.SubCategoriaService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/catalogos/subcategorias")
public class SubCategoriasController {
    private final SubCategoriaService service;
    public SubCategoriasController(SubCategoriaService service) { this.service = service; }
    @GetMapping
    public List<SubCategoria> list() { return service.listAll(); }
}
