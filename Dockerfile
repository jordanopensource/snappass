FROM python:3.8-slim

ENV APP_DIR=/usr/src/snappass

RUN groupadd -r snappass && \
    useradd -r -g snappass snappass && \
    mkdir -p $APP_DIR

WORKDIR $APP_DIR

COPY ["setup.py", "MANIFEST.in", "README.rst", "AUTHORS.rst", "Makefile", "requirements.txt", "$APP_DIR/"]
COPY ["./snappass", "$APP_DIR/snappass"]

RUN apt-get update && \
    apt-get install make

RUN make prod
RUN python setup.py install && \
    chown -R snappass $APP_DIR && \
    chgrp -R snappass $APP_DIR

USER snappass

# Default Flask port
EXPOSE 5000

CMD ["snappass"]
