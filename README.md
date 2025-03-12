Установка и активация сервиса и таймера:

chmod +x /usr/local/bin/monitor_test.sh

systemctl daemon-reload

systemctl enable monitor_test.timer

systemctl start monitor_test.timer
