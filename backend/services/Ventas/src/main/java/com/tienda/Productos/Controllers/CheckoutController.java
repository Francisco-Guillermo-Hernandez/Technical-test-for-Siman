package com.tienda.Productos.Controllers;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import com.tienda.Productos.Services.CartService;
import com.tienda.Productos.DTO.CartDto;
import com.tienda.Productos.DTO.CartItemDto;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;
import org.json.JSONArray;
import org.json.JSONObject;

@RestController
@RequestMapping("/checkout")
public class CheckoutController {

    private final CartService cartService;
    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public CheckoutController(CartService cartService, JdbcTemplate jdbcTemplate) {
        this.cartService = cartService;
        this.jdbcTemplate = jdbcTemplate;
    }

    @PostMapping("/{userId}")
    public ResponseEntity<Map<String, Object>> checkout(@PathVariable Long userId, @RequestBody Map<String, Object> body) {
        CartDto cart = cartService.getCart(userId);
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("error", "Carrito vacío"));
        }

        // Build JSONB array expected by sp_crear_venta: {producto_id, cantidad, precio_unitario}
        JSONArray productos = new JSONArray();
        for (CartItemDto item : cart.getItems()) {
            JSONObject o = new JSONObject();
            o.put("producto_id", item.getProductoId());
            o.put("cantidad", item.getCantidad());
            o.put("precio_unitario", item.getPrecioUnitario());
            productos.put(o);
        }

        Integer clienteId = ((Number) body.getOrDefault("clienteId", userId)).intValue();
        Integer metodoPagoId = body.get("metodoPagoId") == null ? null : ((Number) body.get("metodoPagoId")).intValue();

        String sql = "SELECT sp_crear_venta(?, ?, ?::jsonb)";
        Integer ventaId = jdbcTemplate.queryForObject(sql, Integer.class, clienteId, metodoPagoId, productos.toString());

        // clear cart
        cartService.deleteCart(userId);

        Map<String, Object> resp = new HashMap<>();
        resp.put("ventaId", ventaId);
        return ResponseEntity.ok(resp);
    }
}
