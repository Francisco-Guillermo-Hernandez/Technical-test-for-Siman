package com.tienda.Productos.DAO;

import org.springframework.stereotype.Repository;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.List;
import java.util.Map;

@Repository
public class SalesDao {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public SalesDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<Map<String, Object>> top3Products() {
        String sql = "SELECT ac.producto_id, p.nombre, SUM(ac.cantidad) as total_vendidos " +
                     "FROM articulos_comprados ac JOIN productos p ON ac.producto_id = p.id " +
                     "GROUP BY ac.producto_id, p.nombre ORDER BY total_vendidos DESC LIMIT 3";
        return jdbcTemplate.queryForList(sql);
    }

    public Map<String, Object> topClientByRevenue() {
        String sql = "SELECT v.cliente_id, c.nombre as cliente_nombre, SUM(v.total) as ingreso_total " +
                     "FROM ventas v JOIN clientes c ON v.cliente_id = c.id " +
                     "GROUP BY v.cliente_id, c.nombre ORDER BY ingreso_total DESC LIMIT 1";
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql);
        return rows.isEmpty() ? null : rows.get(0);
    }

    public Map<String, Object> totalIncomeLastMonth() {
        String sql = "SELECT SUM(total) as ingreso_total, COUNT(*) as ventas_count " +
                     "FROM ventas v WHERE v.fecha_compra >= date_trunc('month', CURRENT_DATE - interval '1 month') " +
                     "AND v.fecha_compra < date_trunc('month', CURRENT_DATE)";
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql);
        return rows.isEmpty() ? Map.of("ingreso_total", 0, "ventas_count", 0) : rows.get(0);
    }
}
