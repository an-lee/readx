FROM flyio/postgres-flex:15.3

RUN apt-get update && \
    apt-get install -y --no-install-recommends
RUN apt install -y postgresql-common
RUN /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y
RUN apt install -y postgresql-15-pgvector
