@echo off

REM Creating directories that needed by container
mkdir ".\data\postgresql"
mkdir ".\data\redis"

REM Start Docker Compose
docker-compose -f compose.yml up -d