package com.tienda.Productos.Controllers;

import org.springframework.web.bind.annotation.*;
import com.tienda.Productos.DAO.SalesDao;
import org.springframework.http.ResponseEntity;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/sales")
public class SalesReportController {

    private final SalesDao salesDao;

    public SalesReportController(SalesDao salesDao) {
        this.salesDao = salesDao;
    }

    @GetMapping("/top-products")
    public ResponseEntity<List<Map<String, Object>>> topProducts() {
        return ResponseEntity.ok(salesDao.top3Products());
    }

    @GetMapping("/top-client")
    public ResponseEntity<Map<String, Object>> topClient() {
        Map<String, Object> r = salesDao.topClientByRevenue();
        if (r == null) return ResponseEntity.noContent().build();
        return ResponseEntity.ok(r);
    }

    @GetMapping("/income/last-month")
    public ResponseEntity<Map<String, Object>> incomeLastMonth() {
        return ResponseEntity.ok(salesDao.totalIncomeLastMonth());
    }
}
