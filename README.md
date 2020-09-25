# docker-phpfpm
Docker image for PHP 7.3 FPM with ubuntu bionic

Hi, this repository is intended for use like a base for PHP applications and used primary with Nginx image for my own repositories, if you want extend you can take and add apache, Nginx or other http server.

This repo, is bases in [Ubuntu Bionic Base Image 18.08]

# Files and folders
- Dockerfile
 Build image file
 ## Configs folder
	 - php-fpm.conf: fpm configuration base file

# Enviorement Variables
This image is intented to extend so much posible so here are the enviorement variables for your customization.

-	**PHP_RUN_DIR**:  
	Default directory for run php Run dir.

	Default value: PHP_RUN_DIR=/run/php

-	**PHP_LOG_DIR**:  
	Default directory for php log.

	Default value: PHP_RUN_DIR=/var/log/php

-	**PHP_CONF_DIR**:  
	Default directory for configuration

	Default value: PHP_CONF_DIR=/etc/php/7.3

-	**PHP_DATA_DIR**:  
	Default directory for php data

	Default value: PHP_DATA_DIR=/var/lib/php

-	**PHP_LOG_LEVEL**:  
	PHP Log level

	Default value: PHP_LOG_LEVEL=notice

-	**PHP_ERROR_REPORTING**:  
	PHP error reporting

	Default value: PHP_ERROR_REPORTING="E_ALL"

-	**PHP_DISPLAY_ERRORS**:  
	PHP display errors

	Default value: PHP_DISPLAY_ERRORS=On

-	**PHP_POST_MAX_SIZE**:  
	PHP post max size

	Default value: PHP_POST_MAX_SIZE=25M

-	**PHP_UPLOAD_MAX_SIZE**:  
	PHP upload max size

	Default value: PHP_UPLOAD_MAX_SIZE=20M

-	**FPM_PM_MAX_CHILDREN**:  
	FPM pm.max_childrens

	Default value: FPM_PM_MAX_CHILDREN=5

-	**FPM_PM_START_SERVERS**:  
	FPM pm.start_servers

	Default value: FPM_PM_START_SERVERS=2

-	**FPM_PM_MIN_SPARE_SERVERS**:  
	FPM pm.min_spare_servers
	
	Default value: FPM_PM_MIN_SPARE_SERVERS=1

-	**FPM_PM_MAX_SPARE_SERVERS**:  
	FPM pm.max_spare_servers
	
	Default value: FPM_PM_MAX_SPARE_SERVERS=3

For more information about php.ini directives visit https://www.php.net/manual/en/ini.list.php.

For more information about directives for PHP FPM visit https://php-fpm.org/wiki/.

You can extend this image like you desire. 
Please you can send me a message on my github channel: https://github.com/fakereto.

[Ubuntu Bionic Base Image 18.08]: https://github.com/tianon/docker-brew-ubuntu-core/blob/a5fc6fc792ed9dfc0ddf897178c9e05a0d2a9718/bionic/Dockerfile