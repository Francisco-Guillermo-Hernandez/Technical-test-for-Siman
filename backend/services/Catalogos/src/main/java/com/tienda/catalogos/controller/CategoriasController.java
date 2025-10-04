package com.tienda.catalogos.controller;

import com.tienda.catalogos.entities.Categoria;
import com.tienda.catalogos.service.CategoriaService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/catalogos/categorias")
public class CategoriasController {
    private final CategoriaService categoriaService;
    public CategoriasController(CategoriaService categoriaService) { this.categoriaService = categoriaService; }

    @GetMapping
    public List<Categoria> list() { return categoriaService.listAll(); }
}
