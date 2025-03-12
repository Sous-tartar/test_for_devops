#!/bin/bash

PROCESS_NAME="test"
LOG_FILE="/var/log/monitoring.log"
API_URL="https://test.com/monitoring/test/api"
LAST_PID_FILE="/var/run/${PROCESS_NAME}.pid"

# Проверяем, запущен ли процесс
test_pid=$(pgrep -x "$PROCESS_NAME")

if [ -n "$test_pid" ]; then
    # Проверяем, был ли процесс перезапущен
    if [ -f "$LAST_PID_FILE" ]; then
        last_pid=$(cat "$LAST_PID_FILE")
        if [ "$test_pid" != "$last_pid" ]; then
            echo "$(date) - Процесс $PROCESS_NAME был перезапущен (PID: $test_pid)" >> "$LOG_FILE"
        fi
    fi
    echo "$test_pid" > "$LAST_PID_FILE"

    # Отправляем запрос на мониторинг сервер
    if ! curl -s --head --request GET "$API_URL" | grep "200 OK" > /dev/null; then
        echo "$(date) - Сервер мониторинга недоступен" >> "$LOG_FILE"
    fi
fi
