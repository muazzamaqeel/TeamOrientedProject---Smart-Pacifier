@echo off

cd /d C:\Programming\SmartPacifier-Tool\src\smartpacifier_app\lib\screens\settings\configuration\mosquitto

docker stop pacifier-mqtt
docker rm pacifier-mqtt

docker run -d ^
--name pacifier-mqtt ^
-p 1883:1883 ^
-v C:\Programming\SmartPacifier-Tool\src\smartpacifier_app\lib\screens\settings\configuration\mosquitto\mosquitto.conf:/mosquitto/config/mosquitto.conf ^
eclipse-mosquitto

pause