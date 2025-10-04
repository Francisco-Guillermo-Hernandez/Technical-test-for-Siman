package com.tienda.catalogos.controller;

import com.tienda.catalogos.entities.EstatusProducto;
import com.tienda.catalogos.service.EstatusProductoService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/catalogos/estatus_producto")
public class EstatusProductoController {
    private final EstatusProductoService service;
    public EstatusProductoController(EstatusProductoService service) { this.service = service; }
    @GetMapping
    public List<EstatusProducto> list() { return service.listAll(); }
}
