package com.tienda.Productos.DAO;


import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.tienda.Productos.Entities.*;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.JdbcTemplate;

import java.sql.Types;

@Repository
public class ProductDao {

    
    private final Logger logger = LoggerFactory.getLogger(ProductDao.class);
    private JdbcTemplate jdbcTemplate;
    
    @Autowired
    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }


    public Integer createProduct(Product product) {
        String sql = "SELECT sp_crear_producto(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?::jsonb, ?, ?, ?)";
        try {
            ObjectMapper objectMapper = new ObjectMapper();

            String fichaTecnicaJson = null;
            if (product.getFichaTecnica() != null) {
                fichaTecnicaJson = objectMapper.writeValueAsString(product.getFichaTecnica());
            }

            logger.info("create Product {}", product);

            return jdbcTemplate.queryForObject(
                sql,
                new Object[] {
                    product.getNombre(),
                    product.getPrecio(),
                    product.getCosto(),
                    product.getStock(),
                    product.getDescripcion(),
                    product.getResumen(),
                    product.getSubCategoriaId(),
                    product.getEspecificaciones(),
                    product.getColorId(),
                    product.getStatusId(),
                    product.getSku(),
                    fichaTecnicaJson != null ? fichaTecnicaJson : "{}",
                    product.getMarcaId(),
                    product.getPeso(),
                    product.getDimensiones()
                },
                Integer.class
            );
        } catch (Exception e) {
            throw new RuntimeException("Error creating product", e);
        }
    }

    public Boolean updateProduct(Product product) {
        String sql = "SELECT sp_actualizar_producto(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?::jsonb, ?, ?, ?)";
        try {
            ObjectMapper objectMapper = new ObjectMapper();

            String fichaTecnicaJson = null;
            if (product.getFichaTecnica() != null) {
                fichaTecnicaJson = objectMapper.writeValueAsString(product.getFichaTecnica());
            }

            logger.info("update Product {}", product);

            return jdbcTemplate.queryForObject(
                    sql,
                    new Object[] {
                            product.getId(),
                            product.getNombre(),
                            product.getPrecio(),
                            product.getCosto(),
                            product.getStock(),
                            product.getDescripcion(),
                            product.getResumen(),
                            product.getSubCategoriaId(),
                            product.getEspecificaciones(),
                            product.getColorId(),
                            product.getStatusId(),
                            product.getSku(),
                            fichaTecnicaJson != null ? fichaTecnicaJson : "{}",
                            product.getMarcaId(),
                            product.getPeso(),
                            product.getDimensiones()
                    },
                    Boolean.class);
        } catch (Exception e) {
            throw new RuntimeException("Error updating product", e);
        }
    }

    public List<Product> filterProducts(ProductFilter filter) {
        String sql = """
            SELECT * FROM sp_filtrar_productos_avanzado(
                ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
            )
            """;
            
        return jdbcTemplate.query(sql, ps -> {
            ps.setObject(1, filter.getName());
            ps.setObject(2, filter.getCategoryId());
            ps.setObject(3, filter.getSubCategoryId());
            ps.setObject(4, filter.getBrandId());
            ps.setObject(5, filter.getColorId());
            ps.setObject(6, filter.getStatusId());
            ps.setObject(7, filter.getMinPrice());
            ps.setObject(8, filter.getMaxPrice());
            ps.setObject(9, filter.getStockStatus());
            ps.setObject(10, filter.getActive());
        }, new ProductRowMapper());
    }

    private static class ProductRowMapper implements RowMapper<Product> {
        @Override
        public Product mapRow(ResultSet rs, int rowNum) throws SQLException {
            Product product = new Product();
            product.setId(rs.getInt("id"));
            product.setNombre(rs.getString("nombre"));
            product.setPrecio(rs.getBigDecimal("precio"));
            product.setCosto(rs.getBigDecimal("costo"));
            product.setStock(rs.getInt("stock"));
            product.setDescripcion(rs.getString("descripcion"));
            product.setResumen(rs.getString("resumen"));
            product.setSubCategoriaId(rs.getInt("sub_categoria_id"));
            product.setEspecificaciones(rs.getString("especificaciones"));
            product.setColorId(rs.getInt("color_id"));
            product.setStatusId(rs.getInt("status_id"));
            product.setSku(rs.getString("sku"));
            // product.setTechnicalSheet(rs.getString("ficha_tecnica") != null ? 
            //     new org.json.JSONObject(rs.getString("ficha_tecnica")) : null);
            product.setMarcaId(rs.getInt("marca_id"));
            product.setPeso(rs.getBigDecimal("peso"));
            product.setDimensiones(rs.getString("dimensiones"));
            product.setActivo(rs.getBoolean("activo"));
            product.setCreatedAt(rs.getTimestamp("created_at"));
            product.setUpdatedAt(rs.getTimestamp("updated_at"));
            
            return product;
        }
    }

    public Product getProductById(long id) {
        String sql = "SELECT * FROM productos WHERE id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new ProductRowMapper(), id);
        } catch (Exception e) {
            throw e;
        }
    }

   
    public Map<String, Object> getAllActiveProducts(int page, int pageSize) {
    try {
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM productos WHERE activo = true ORDER BY created_at DESC LIMIT ? OFFSET ?";
        List<Product> products = jdbcTemplate.query(sql, new ProductRowMapper(), pageSize, offset);

        String countSql = "SELECT COUNT(*) FROM productos WHERE activo = true";
        Integer total = jdbcTemplate.queryForObject(countSql, Integer.class);

        int totalPages = (int) Math.ceil((double) total / pageSize);
        boolean hasNext = page < totalPages;
        boolean hasPrev = page > 1;

        java.util.Map<String, Object> result = new java.util.HashMap<>();
        result.put("products", products);
        result.put("total", total);
        result.put("page", page);
        result.put("totalPages", totalPages);
        result.put("hasNext", hasNext);
        result.put("hasPrev", hasPrev);

        return result;
    } catch (Exception e) {
        return null;
    }
    }
}

