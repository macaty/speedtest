FROM  php:apache

# Install extensions
#RUN export https_proxy=http://172.18.220.3:7890 http_proxy=http://172.18.220.3:7890 all_proxy=socks5://172.18.220.3:7891
RUN apt-get update && apt upgrade -y && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
#RUN unset https_proxy && unset http_proxy && unset all_proxy

#拷贝文件
RUN rm -rf /var/www/html/*
COPY backend /var/www/html/
COPY *.js /var/www/html/
COPY example-singleServer-pretty.html /var/www/html/index.html

#设置权限
RUN chown -R www-data /var/www/html/*

#启动

EXPOSE 80
CMD ["apache2-foreground"]
