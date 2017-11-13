FROM tomcat:8.0-jre8

RUN apt-get -y update \
  && apt-get install -y libgdal-java \
    git

# boundless
RUN git clone https://github.com/mxabierto/docker-boundless-suite suite \
  && wget -q https://www.dropbox.com/s/15ot9ubx35mr0aa/BoundlessSuite-4.9.1-war.zip?dl=0 -O boundless.zip \
  && wget -q https://www.dropbox.com/s/c5j07wtmt4e9u8e/BoundlessSuite-4.9.1-ext.zip?dl=0 -O boundless-ext.zip

# geoserver
RUN mkdir -v -p ./suite \
    ./geoserver \
    ./webapps/geowebcache \
    /var/opt/boundless/server/geowebcache/config \
    /var/opt/boundless/server/geowebcache/tilecache \
  && unzip boundless.zip -d suite \
  && unzip boundless-ext.zip -d suite \
  && unzip suite/BoundlessSuite-latest-war/geoserver.war -d geoserver \
  && unzip suite/BoundlessSuite-latest-war/geowebcache.war -d ./webapps/geowebcache

# data folder
RUN mkdir -p /var/opt/boundless/server/geoserver/data/jdbcconfig \
  && unzip suite/BoundlessSuite-latest-war/suite-data-dir.zip -d /var/opt/boundless/server/geoserver/data

# extensions
RUN cp -t geoserver/WEB-INF/lib \
    suite/BoundlessSuite-latest-ext/vectortiles/* \
    suite/BoundlessSuite-latest-ext/wps/* \
    suite/BoundlessSuite-latest-ext/jdbcconfig/* \
  && cp suite/BoundlessSuite-latest-ext/marlin/marlin-0.7.3-Unsafe.jar lib

# config files
RUN mkdir -p -v conf/Catalina/localhost \
  && cp -t conf/Catalina/localhost/ \
    suite/geowebcache.xml \
    suite/geoserver.xml

# set suite
RUN mv geoserver webapps/ \
  && cp -t webapps \
    suite/BoundlessSuite-latest-war/composer.war \
    suite/BoundlessSuite-latest-war/dashboard.war \
    suite/BoundlessSuite-latest-war/geowebcache.war \
    suite/BoundlessSuite-latest-war/quickview.war \
    suite/BoundlessSuite-latest-war/suite-docs.war \
    suite/BoundlessSuite-latest-war/wpsbuilder.war

# clean
RUN rm -rf suite *.zip

EXPOSE 8080
