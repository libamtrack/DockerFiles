# DockerFiles
Dockerfile that creates image with compiled libamtrack core to JavaScript.

Commands
to build
```
docker-compose build
```

to build without using cache
```
docker-compose build --no-cache
```

to start container
```
docker-compose up
```

to inspect container
```
docker-compose exec libamtrack bash
```

copy compiled library to current directory ( need first docker-compose up)
```
docker cp libamtrack:/libat.js .
docker cp libamtrack:/libat.wasm .
```

If you want to compile without WASM change in docker-compose.yml WASM to 0