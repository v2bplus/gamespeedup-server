#!/bin/bash

docker exec WEB_php82 sh -c "cd /www/admin_api/application/bin && ./start_resque.sh stop && sleep 1 && ./start_resque.sh start"
