FROM nginx:mainline-perl
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

RUN apt-get update -y --fix-missing \
    && apt-get upgrade -y \
    && apt-get install -y \
      gnupg2 \
      curl \
    && curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update -y --fix-missing && apt-get install -y \
      syncthing \
      supervisor \
      gvfs \
      vim \
      procps \
      apt-utils \
      zip \
      unzip \
      xvfb \
      libxi6 \
      libgconf-2-4 \
      gnupg2 \
      google-chrome-stable \
    && mkdir -p /usr/share/man/man1 \
    && apt-get update -y --fix-missing  \
    && apt-get -yf install default-jre-headless default-jdk-headless default-jre default-jdk \
    && wget https://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && mv chromedriver /usr/bin/chromedriver \
    && chown root:root /usr/bin/chromedriver \
    && chmod +x /usr/bin/chromedriver \
    && wget https://selenium-release.storage.googleapis.com/3.9/selenium-server-standalone-3.9.1.jar \
    && mv selenium-server-standalone-3.9.1.jar /opt/selenium-server-standalone.jar \
    && chmod +x /docker-entrypoint.sh  \
    && rm -rf /var/lib/apt/lists/*

COPY ./nginx /etc/nginx
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
WORKDIR /

EXPOSE 80

STOPSIGNAL SIGTERM

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD ["nginx", "-g", "daemon off;"]
