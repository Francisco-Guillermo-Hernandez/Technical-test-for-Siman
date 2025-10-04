package com.tienda.catalogos.Exceptions;


public class BadRequestException extends RuntimeException  {
    public BadRequestException(String message) {
        super(message);
    }
}
