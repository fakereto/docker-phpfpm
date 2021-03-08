#!/bin/bash

# Docker general functions for use on docker entrypoint files

# logging functions
docker_log() {
	local type="$1"; shift
	printf '%s [%s] [Entrypoint]: %s\n' "$(date --rfc-3339=seconds)" "$type" "$*"
}

# logging a note
log_note() {
	docker_log Note "$@"
}
# logging a warning
log_warn() {
	docker_log Warn "$@" >&2
}
# logging a error
log_error() {
	docker_log ERROR "$@" >&2
	exit 1
}

# check to see if this file is being run or sourced from another script
_is_sourced() {
        # https://unix.stackexchange.com/a/215279
        [ "${#FUNCNAME[@]}" -ge 2 ] \
                && [ "${FUNCNAME[0]}" = '_is_sourced' ] \
                && [ "${FUNCNAME[1]}" = 'source' ]
}

# Function for load system env variables from _FILE var
# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DATA_PASSWORD' 'example'
# (will allow for "$XYZ_DATA_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DATA_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		log_error "\nBoth $var and $fileVar are set (but are exclusive)\n"
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi

	export "$var"="$val"
	unset "$fileVar"
}