package com.tienda.Productos.Controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestParam;

import com.tienda.Productos.Entities.*;
import com.tienda.Productos.Exceptions.*;
import com.tienda.Productos.Services.ProductService;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.mvc.support.DefaultHandlerExceptionResolver;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PutMapping;

import com.tienda.Productos.DTO.ProductDto;
import com.tienda.Productos.Entities.Product;
import jakarta.validation.Valid;



@RestController
@RequestMapping("/products")
public class ProductController {


    private final ProductService productService;
    private final Logger logger = LoggerFactory.getLogger(ProductController.class);

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/count")
    public int getCount() {
        return 9;
    }


    @PostMapping("/")
    public Object createProduct(
        @Valid
        @RequestBody Product product
    ) {

        var p = new Product();

        p.setDescripcion(product.getDescripcion());
        p.setActivo(product.getActivo());
        p.setNombre(product.getNombre());
        p.setPrecio(product.getPrecio());
        p.setSubCategoriaId(product.getSubCategoriaId());
        p.setMarcaId(product.getMarcaId());
        p.setStock(product.getStock());
        
        return this.productService.createProduct(p);
    }

    @PutMapping("path/{id}")
    public Object updateProduct(@PathVariable String id, @RequestBody String entity) {
        
        
        return entity;
    }
    


    @GetMapping("/")
    public Map<String, Object>getProducts (
        @RequestParam( required = false, defaultValue = "1") int page,
        @RequestParam(required = false, defaultValue = "10") int pageSize)
         {

       try {
            if (pageSize > 20) {
                throw new BadRequestException("No puede solicitar más de 20 elementos por página");
            }
            return this.productService.getAllActiveProducts(page, pageSize);
       } catch (EmptyResultDataAccessException e ) {
            throw new ResourceNotFoundException("El producto no existe");
        } 
       
    }

    @GetMapping("/{productId}")
    public Product getProductById(@PathVariable("productId") long productId) {
       try {
                return this.productService.getProductById(productId);
            } catch (EmptyResultDataAccessException e ) {
                throw new ResourceNotFoundException("El producto no existe");
            } catch (MethodArgumentTypeMismatchException e) {
                throw new BadRequestException("El formato es invalido");
            } catch (NumberFormatException e ) {
                throw new BadFormatException("Se produjo un error");
            }
    }
    

    @GetMapping("/filter")
    public List<Product> filterProducts(@RequestParam("filter") List<String> filters) {


        ProductFilter filter = new ProductFilter();
        filter.setBrandId(1);
       return this.productService.filterProducts(filter);
    }
    
}
