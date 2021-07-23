#!/bin/sh
exec >logfile.txt 2>&1
cd /workspace/development
if [ -d "./frappe-bench" ]
    then
    echo "Bench exists"
else

    bench init --skip-redis-config-generation --frappe-path https://github.com/Bloomstack/frappe.git --frappe-branch staging frappe-bench
    cd /workspace/development/frappe-bench

    bench setup requirements && bench build

    bench get-app https://github.com/Bloomstack/erpnext.git

    bench get-app https://github.com/Bloomstack/bloomstack_core.git

    cp -r /tmp/.vscode /workspace/development

fi
cd /workspace/development/frappe-bench
bench set-mariadb-host mariadb
bench set-redis-cache-host redis:6379/1
bench set-redis-queue-host redis:6379/2
bench set-redis-socketio-host redis:6379/3
bench config set-common-config -c developer_mode 1
bench config set-common-config -c mute_emails 1

bash -c "sleep infinity"