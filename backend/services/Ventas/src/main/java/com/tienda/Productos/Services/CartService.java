package com.tienda.Productos.Services;

import org.springframework.stereotype.Service;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.beans.factory.annotation.Autowired;
import java.time.Duration;
import com.tienda.Productos.DTO.CartDto;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.DeserializationFeature;

@Service
public class CartService {

    private final RedisTemplate<String, Object> redisTemplate;
    private final Duration ttl = Duration.ofHours(12);
    private final ObjectMapper objectMapper;

    public CartService(RedisTemplate<String, Object> redisTemplate) {
        this.redisTemplate = redisTemplate;
        this.objectMapper = new ObjectMapper()
            .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }

    public void saveCart(Long userId, CartDto cart) {
        String key = cartKey(userId);
        ValueOperations<String, Object> ops = redisTemplate.opsForValue();
        ops.set(key, cart, ttl);
    }

    public CartDto getCart(Long userId) {
        String key = cartKey(userId);
        ValueOperations<String, Object> ops = redisTemplate.opsForValue();
        Object v = ops.get(key);
        if (v == null) return null;

        // Safe conversion: redis returns LinkedHashMap when using generic serializer
        try {
            return objectMapper.convertValue(v, CartDto.class);
        } catch (IllegalArgumentException ex) {
            return null;
        }
    }

    public void deleteCart(Long userId) {
        redisTemplate.delete(cartKey(userId));
    }

    private String cartKey(Long userId) {
        return "cart:user:" + userId;
    }
}
