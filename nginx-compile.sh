#change it to latest version
NPS_VERSION=1.11.33.0;
echo "Changing Directory to $HOME..."
cd $HOME;
echo "Nginx version to install: " && \
read NGINX_VERSION && \
echo "Downloading nginx-$NGINX_VERSION..." && \
wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz && \

echo "Installing Nginx Dependencies..." && \
sudo apt-get -qq -y install checkinstall build-essential software-properties-common git libssl-dev openssl libpcre3 libpcre3-dev zlib1g zlib1g-dbg zlib1g-dev && \
tar xzf nginx-* && rm $HOME/nginx-*.tar.gz && \
cd nginx-*/ && \
mkdir modules && cd modules && \
echo 'cloning nginx-rtmp-module and ngx_cache_purge modules' && \
git clone https://github.com/arut/nginx-rtmp-module && git clone https://github.com/FRiCKLE/ngx_cache_purge && \

#https://developers.google.com/speed/pagespeed/module/build_ngx_pagespeed_from_source#build-instructions
echo 'fetching pagespeed module' && \
curl -fsSOL https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.tar.gz && \
tar xzf release-${NPS_VERSION}-beta.tar.gz && \
cd ngx_pagespeed-release-${NPS_VERSION}-beta/ && \
curl -fsSOL https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz && \
tar -xzvf ${NPS_VERSION}.tar.gz && \ # extracts to psol/
cd $HOME/nginx-* && ./configure --prefix=/etc/nginx \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--with-http_ssl_module \
--with-http_headers_module \
--with-http_gzip_module \
--with-http_limit_req_module \
--with-http_log_module \
--with-http_upstream_module \
--with-http_v2_module \
--with-http_proxy_module \
--with-http_auth_basic_module \
--with-http_fastcgi_module \
--with-http_spdy_module \
--with-http_access_module \
--with-http_charset_module \
--with-http_rewrite_module \
--with-http_memcached_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_stub_status_module \
--with-http_mp4_module \
--with-pcre \
--with-file-aio \
--with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -DTCP_FASTOPEN=23' \
--with-ld-opt='-Wl,-z,relro -Wl,--as-needed -L /usr/lib' \
--with-ipv6 \
--with-debug \
--without-http_scgi_module \
--without-http_uwsgi_module \
--add-module=./modules/ngx_cache_purge \
--add-module=./modules/ngx_pagespeed-release-${NPS_VERSION}-beta && \
make && \
sudo checkinstall --install=no -y && \
sudo dpkg -i *.deb && \
#create necessary directories
sudo mkdir -p /etc/nginx/sites-avaiable && sudo chmod 755 /etc/nginx/sites-avaiable && \
sudo mkdir -p /etc/nginx/sites-enabled && sudo chmod 755 /etc/nginx/sites-enabled && \
sudo mkdir -p /etc/nginx/conf.d && sudo chmod 755 /etc/nginx/conf.d && sudo mkdir -p /var/log/nginx;
