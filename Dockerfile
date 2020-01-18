FROM debian:stretch

# https://www.sitepoint.com/optimizing-docker-based-ci-runners-shared-package-caches/
ENV COMPOSER_CACHE_DIR /cache/composer
ENV YARN_CACHE_FOLDER /cache/yarn
ENV NPM_CONFIG_CACHE /cache/npm
ENV bower_storage__packages /cache/bower
ENV GEM_SPEC_CACHE /cache/gem
ENV PIP_DOWNLOAD_CACHE /cache/pip

# https://github.com/phusion/baseimage-docker/issues/319
# RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# SSH
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh/ && \
    apt-get update -y && apt-get -y clean && \
    apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev libpng-dev && \
    apt-get install -y rsync git openssh-client zip unzip wget && \
    git clone https://github.com/git-ftp/git-ftp.git && \
    cd git-ftp && \
    tag="$(git tag | grep '^[0-9]*\.[0-9]*\.[0-9]*$' | tail -1)" && \
    git checkout "$tag" && \
    git checkout "1.4.0" && \
    make install && \
    cd .. && \
    git ftp --version && \
    rm -rf git-ftp && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -y && \
    apt-get install -y nodejs python-dev python-pip && \
    pip install aws-shell && \
    apt-get install -y yarn && \
    npm install -g npm && \
    yarn global add gulp-cli bower node-sass && \
    apt-get -y install apt-transport-https lsb-release ca-certificates && \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt-get update && \
    apt-get -y install apache2 php7.2 php7.2-common php7.2-xml php7.2-gd php7.2-mysql php7.2-dom php7.2-mbstring php7.2-intl php7.2-zip php7.2-curl php7.2-bcmath && \
    wget https://getcomposer.org/installer -O composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php --version && \
    composer --version && \
    rm composer-setup.php && \
    rm -rf /var/lib/apt/lists/*