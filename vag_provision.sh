sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install dselect -y
sudo dselect update
sudo DEBIAN_FRONTEND=noninteractive apt-get dselect-upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install apache2-utils nginx redis-server curl git mariadb-server mariadb-client libmagickwand-dev imagemagick -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install php5-dev php5-fpm php5-mysql php5-common php5-gd php5-json php5-cli php5-curl php5-cli php5-redis php5-xdebug php-pear php5-mcrypt -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install php5-imap php5-oauth php5-memcached php5-odbc -y
sudo curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

sudo php5enmod mcrypt
sudo yes | sudo pecl install xhprof-beta imagick

sudo bash -c 'echo "extension=imagick.so" > /etc/php5/mods-available/imagick.ini'
sudo bash -c 'echo "extension=xhprof.so" > /etc/php5/mods-available/xhprof.ini'

sudo php5enmod opcache pdo curl gd imap json mcrypt memcached mysql mysqli odbc pdo_mysql pdo_odbc readline imagick

sudo mysqladmin -u root password newPassword

sudo bash -c 'cat << EOF > /etc/nginx/sites-enabled/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    ssl off;
    server_name *.com;
    server_name *.dev;

    #return 301 https://\$server_name\$request_uri;

    root /var/www/public/;

    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
        proxy_read_timeout 300;
    }

    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }

    location ~ \.php\$ {
        try_files \$uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_pass 127.0.0.1:9000;
        #fastcgi_pass /var/run/php5-fpm.sock;
        fastcgi_read_timeout 300;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location = /.env {
        deny all;
    }

}
EOF'


sudo bash -c 'cat << EOF > /etc/php5/fpm/pool.d/www.conf 
[www]
user = www-data
group = www-data
listen = 127.0.0.1:9000
listen.owner = www-data
listen.group = www-data
listen.allowed_clients = 127.0.0.1
pm = dynamic
pm.max_children = 10
pm.start_servers = 2
pm.min_spare_servers = 2
pm.max_spare_servers = 5
pm.max_requests = 50000
chdir = /
EOF'

sudo service nginx stop
sudo service php5-fpm stop
sudo service php5-fpm start
sudo service nginx start
