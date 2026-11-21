#!/bin/bash
cd "$(dirname "$0")"
sudo -u postgres psql -c "DROP DATABASE IF EXISTS cinema_db;"
sudo -u postgres psql -c "CREATE DATABASE cinema_db;"
for f in lab1_base/schema.sql lab1_base/data.sql lab2_base/00_extension.sql lab2_base/01_data.sql 01_control_data.sql 02_analytics.sql 03_control_check.sql 04_views.sql 05_materialized_view.sql; do
    echo "##### $f #####"
    sudo -u postgres psql -d cinema_db < "$f"
done
