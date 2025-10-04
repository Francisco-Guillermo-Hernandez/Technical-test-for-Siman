package com.tienda.Productos.Controllers;

import org.springframework.web.bind.annotation.*;
import com.tienda.Productos.Services.CartService;
import com.tienda.Productos.DTO.CartDto;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/cart")
public class CartController {

    private final CartService cartService;

    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    @PostMapping("/{userId}")
    public ResponseEntity<?> saveCart(@PathVariable Long userId, @RequestBody CartDto cart) {
        cart.setUserId(userId);
        cartService.saveCart(userId, cart);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{userId}")
    public ResponseEntity<CartDto> getCart(@PathVariable Long userId) {
        CartDto cart = cartService.getCart(userId);
        if (cart == null) return ResponseEntity.notFound().build();
        return ResponseEntity.ok(cart);
    }

    @DeleteMapping("/{userId}")
    public ResponseEntity<?> deleteCart(@PathVariable Long userId) {
        cartService.deleteCart(userId);
        return ResponseEntity.noContent().build();
    }
}
