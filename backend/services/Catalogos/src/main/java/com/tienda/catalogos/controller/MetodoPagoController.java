package com.tienda.catalogos.controller;

import com.tienda.catalogos.entities.MetodoPago;
import com.tienda.catalogos.service.MetodoPagoService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/catalogos/metodosPago")
public class MetodoPagoController {
    private final MetodoPagoService service;
    public MetodoPagoController(MetodoPagoService service) { this.service = service; }
    @GetMapping
    public List<MetodoPago> list() { return service.listAll(); }
}
