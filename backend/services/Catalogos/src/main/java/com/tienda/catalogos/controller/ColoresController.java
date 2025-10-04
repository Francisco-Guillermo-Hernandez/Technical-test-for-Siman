package com.tienda.catalogos.controller;

import com.tienda.catalogos.entities.Color;
import com.tienda.catalogos.service.ColorService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/catalogos/x")
public class ColoresController {
    private final ColorService service;
    public ColoresController(ColorService service) { this.service = service; }
    @GetMapping
    public List<Color> list() { return service.listAll(); }
}
