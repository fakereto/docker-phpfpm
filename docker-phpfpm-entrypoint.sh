#!/bin/bash
set -e
source /var/www/base.sh

php_setfpm_config() {
    
    # write the php-fpm config
    { \
        echo "[www]"; \
        echo "user = www-data" ; \
        echo "group = www-data"; \
        echo listen = "$PHP_RUN_DIR"/php-fpm.sock; \
        echo listen.owner = www-data; \
        echo listen.group = www-data; \
        echo ping.path = /ping; \
        echo pm = dynamic; \
        echo pm.status_path = /status; \
        echo pm.max_children = "$FPM_PM_MAX_CHILDREN"; \
        echo pm.start_servers = "$FPM_PM_START_SERVERS"; \
        echo pm.min_spare_servers = "$FPM_PM_MIN_SPARE_SERVERS"; \
        echo pm.max_spare_servers = "$FPM_PM_MAX_SPARE_SERVERS"; \
        echo clear_env = no; \
        echo "; Ensure worker stdout and stderr are sent to the main error log."; \
        echo catch_workers_output = yes
    } > $PHP_CONF_DIR/fpm/pool.d/www.conf
}

php_setphpcustom_config() {
    # write the php-fpm config
    { \
        echo variables_order = "EGPCS"; \
        echo default_charset = "UTF-8"; \
        echo cgi.fix_pathinfo = 0; \
        #Default Value: E_ALL & ~E_NOTICE & ~E_STRICT & ~E_DEPRECATED
        #Development Value: E_ALL
        #Production Value: E_ALL & ~E_DEPRECATED & ~E_STRICT
        echo error_reporting = "$PHP_ERROR_REPORTING"; \
        #Default Value: On
        #Development Value: On
        #Production Value: Off
        echo display_errors = "$PHP_DISPLAY_ERRORS"; \
        echo post_max_size = $PHP_POST_MAX_SIZE; \
        echo upload_max_filesize = $PHP_UPLOAD_MAX_SIZE; \
    } > ${PHP_CONF_DIR}/fpm/conf.d/custom.ini
}

_main() {
    php_setfpm_config
    php_setphpcustom_config
    exec "$@"
}

# If we are sourced from elsewhere, don't perform any further actions
if ! _is_sourced; then
	_main "$@"
fi