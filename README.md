


```bash

chmod +x database/init-scripts/*.sql

```


```bash
openssl genrsa -out private.key 2048
```


```bash
# Construye las imagenes de los proyectos, los servicios, el frontend 
docker compose build  

# incia los contenedores.
docker compose up 

# detiene y remueve los contenedores 
docker compose down

# destruye los volumenes 
docker volume prune

```


```bash

./gradlew bootRun
```

```
http://localhost:5050/
http://localhost:5050/dashboard/new-product


```