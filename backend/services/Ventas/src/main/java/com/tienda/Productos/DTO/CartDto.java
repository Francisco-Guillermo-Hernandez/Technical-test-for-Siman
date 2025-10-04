package com.tienda.Productos.DTO;

import java.util.List;

public class CartDto {
    private Long userId;
    private List<CartItemDto> items;

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public List<CartItemDto> getItems() { return items; }
    public void setItems(List<CartItemDto> items) { this.items = items; }
}
