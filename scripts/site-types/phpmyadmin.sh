#!/usr/bin/env bash

declare -A params=$6       # Create an associative array
declare -A headers=${9}    # Create an associative array
declare -A rewrites=${10}  # Create an associative array

# From https://stackoverflow.com/a/59825964/5155484
VERSION_INFO="$(curl -sS 'https://www.phpmyadmin.net/home_page/version.txt')"
LATEST_VERSION="$(echo -e "$VERSION_INFO" | head -n 1)"
LATEST_VERSION_URL="$(echo -e "$VERSION_INFO" | tail -n 1)"
# We want the .tar.gz version
LATEST_VERSION_URL="${LATEST_VERSION_URL/.zip/.tar.gz}"

echo "Downloading phpMyAdmin $LATEST_VERSION ($LATEST_VERSION_URL)"
curl $LATEST_VERSION_URL -q -# -o 'phpmyadmin.tar.gz'

mkdir "$2" && tar xf phpmyadmin.tar.gz -C "$2" --strip-components 1
rm phpmyadmin.tar.gz

CONFIG_FILE="$2/config.inc.php"

cp "$2/config.sample.inc.php" $CONFIG_FILE

sed -i "s/blowfish_secret'\] = .*/blowfish_secret'\] = 'eYFROnr9XiDsKs8DKs8hTv9XiDsKs8hiDsKs8h0Fnr9s8hTv9XsKs8h0F8DKs8hTv9XiDsKs8h0F9mvo';/" $CONFIG_FILE
sed -i "s/'UploadDir'\] = .*/'UploadDir'\] = '\/tmp\/phpmyadmin';/" $CONFIG_FILE
sed -i "s/'SaveDir'\] = .*/'SaveDir'\] = '\/tmp\/phpmyadmin';/" $CONFIG_FILE
echo "\$cfg['TempDir'] = '/tmp';" >> $CONFIG_FILE


paramsTXT=""
if [ -n "$6" ]; then
   for element in "${!params[@]}"
   do
      paramsTXT="${paramsTXT}
      fastcgi_param ${element} ${params[$element]};"
   done
fi
headersTXT=""
if [ -n "${9}" ]; then
   for element in "${!headers[@]}"
   do
      headersTXT="${headersTXT}
      add_header ${element} ${headers[$element]};"
   done
fi
rewritesTXT=""
if [ -n "${10}" ]; then
   for element in "${!rewrites[@]}"
   do
      rewritesTXT="${rewritesTXT}
      location ~ ${element} { if (!-f \$request_filename) { return 301 ${rewrites[$element]}; } }"
   done
fi

if [ "$7" = "true" ]
then configureXhgui="
location /xhgui {
        try_files \$uri \$uri/ /xhgui/index.php?\$args;
}
"
else configureXhgui=""
fi

block="server {
    listen ${3:-80};
    listen ${4:-443} ssl http2;
    server_name .$1;
    root \"$2\";

    index index.html index.htm index.php;

    charset utf-8;

    $rewritesTXT

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
        $headersTXT
    }

    $configureXhgui

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/nginx/$1-error.log error;

    sendfile off;

    client_max_body_size 12G;

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php$5-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        $paramsTXT

        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 900;
        fastcgi_send_timeout 900;
        fastcgi_read_timeout 900;
    }

    location ~ /\.ht {
        deny all;
    }

    ssl_certificate     /etc/ssl/certs/$1.crt;
    ssl_certificate_key /etc/ssl/certs/$1.key;
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"

sudo sed -i "s/memory_limit = .*/memory_limit = 128M/" /etc/php/$5/fpm/php.ini
sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 12G/" /etc/php/$5/fpm/php.ini
sudo sed -i "s/post_max_size = .*/post_max_size = 12G/" /etc/php/$5/fpm/php.ini
