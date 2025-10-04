
package com.tienda.Productos.Services;

import org.springframework.stereotype.Service;

import com.tienda.Productos.DAO.ProductDao;
import com.tienda.Productos.Entities.*;

import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.Map;

@Service
public class ProductService {

    @Autowired
    private ProductDao productDao;

    public Integer createProduct(Product product) {
        return productDao.createProduct(product);
    }

    public int updateProduct(Product product) {
        return productDao.updateProduct(product);
    }

    public List<Product> filterProducts(ProductFilter filter) {
        return productDao.filterProducts(filter);
    }

    public Product getProductById(long id) {
        return productDao.getProductById(id);
    }

    public Map<String, Object> getAllActiveProducts(int page, int pageSize) {
        return productDao.getAllActiveProducts(page, pageSize);
    }
}
