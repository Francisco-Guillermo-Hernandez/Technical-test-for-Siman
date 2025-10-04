


```bash

chmod +x database/init-scripts/*.sql

```


```bash
openssl genrsa -out private.key 2048
```


```bash
docker compose build  

# incia los contenedores.
docker compose up 

# detiene y remoueve los contenedores 
docker compose down

# destruye los volumenes 
docker volume prune

```


```bash

./gradlew bootRun
```