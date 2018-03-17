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

## ДЗ №19

Развернут сервер CI/CD gitlab-ci. Настроен pipeline для тестового приложения reddit.

## ДЗ №20

Cозданы окружения dev, stage, production, настроен pipeline для работы с окружениями. Настроено создание динамического окружения для отдельных веток.

## ДЗ №21

Докер хаб с образами: <https://hub.docker.com/r/raian13/>
Настроен и запущен prometheus; настроен мониторинг микросервисов ui, comment и самого prometheus. Настроен мониторинг ноды с докер-контейнерами с использованием node-exporter, мониторинг MongoDB с использованием mongodb-exporter.

## ДЗ №23

Докер хаб с образами: <https://hub.docker.com/r/raian13/>
Опробована работа со следующими продуктами: cAdvisor для мониторинга Docker-контейнеров, с отдачей метрик в Prometheus; Grafana - визуализация метрик из Prometheus; алертинг из Prometheus в Slack.  

## ДЗ №25

Опробована работа с централизованным логированием на основе стека Elasticsearch + Fluentd + Kibana. Разобран парсинг логов с помощью grok-шаблонов.  
Выполнено первое задание со звездочкой со стр. 41 - разбираются оба формата логов UI-сервиса.  
Опробована работа с распределенным трейсингом на основе Zipkin.

## ДЗ №27

Развернут кластер Docker Swarm с тестовым приложением и мониторингом. Сервисы приложения описаны в docker/docker-compose.yml, мониторинг - в docker-compose.monitoring-swarm.yml.  
Команда для деплоя кластера:  
docker stack deploy --compose-file=<(docker-compose -f docker-compose.yml -f docker-compose.monitoring-swarm.yml config 2>/dev/null) DEV

### Поведение контейнеров после добавления третьего worker

После добавления worker-3 на нем сразу был поднят контейнер с node-exporter - т.к. этот сервис деплоится в global режиме.  
После увеличения числа реплик до 3 и docker stack deploy... - на worker-3 появилось по одному экземпляру ui, post и comment сервисов.
