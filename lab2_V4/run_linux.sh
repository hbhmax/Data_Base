#!/bin/bash
cd "$(dirname "$0")"
sudo -u postgres psql -c "DROP DATABASE IF EXISTS cinema_db;"
sudo -u postgres psql -c "CREATE DATABASE cinema_db;"
for f in lab1_base/schema.sql lab1_base/data.sql 00_extension.sql 01_data.sql 02_dml.sql 03_queries.sql; do
    echo "##### $f #####"
    sudo -u postgres psql -d cinema_db < "$f"
done
