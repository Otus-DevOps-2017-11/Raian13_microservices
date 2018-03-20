FROM python:3.6.0-alpine

RUN pip install flask pymongo

WORKDIR /app
COPY . /app/

RUN BUILD_PACKAGES="gcc build-base linux-headers" \
&& apk add --no-cache $BUILD_PACKAGES \
&& pip install -r /app/requirements.txt \
&& apk del $BUILD_PACKAGES

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

CMD ["python3", "post_app.py"]
