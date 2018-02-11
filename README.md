# Microservices

## ДЗ №16

Созданы образы для микросервисов: post, comment, ui. Опробована работа с volume - для сохранения данных при пересоздании контейнеров.

### Ответ на вопрос ДЗ, стр. 13

Сборка ui начинается не с первого слоя, потому что часть слоев берется из кэша - первые 5 шагов одинаковы для comment и ui, и при сборке ui докер использует закэшированные слои от comment.  

### Задание со * 1 - переопределение переменных окружения при запуске контейнера

docker run -d --network=reddit --network-alias=node_db mongo:latest  
docker run -d --network=reddit --network-alias=node_post -e "POST_DATABASE_HOST=node_db" raian13/post:1.0  
docker run -d --network=reddit --network-alias=node_comment -e "COMMENT_DATABASE_HOST=node_db" raian13/comment:1.0  
docker run -d --network=reddit -e "POST_SERVICE_HOST=node_post" -e "COMMENT_SERVICE_HOST=node_comment" -p 9292:9292 raian13/ui:1.0

### Задание со * 2 - собрать образ на основе alpine

Dockerfile ui на основе ubuntu - в коммите 5af4213
Dockerfile ui на основе alpine - в коммите 09a65a0

## ДЗ №17

### Вопрос на стр.12

Начиная со 2 экземпляра, контейнеры nginx не запускаются, падая с ошибкой  
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)  
Причина - каждый новый контейнер при запуске с опцией --network host получает один и тот же набор сетевых адресов (= адреса хост-машины) и пытается поднять nginx на этих адресах. Т.к. первый контейнер уже занял порт - возникает ошибка.

### Задание со * на стр. 36

Базовое имя проекта по умолчанию соответствует имени каталога, в котором размещается docker-compose.yml. Чтобы изменить его - надо в .env задать переменную COMPOSE_PROJECT_NAME
