FROM debian:8
MAINTAINER Matthias Thubauville

ENV DEBIAN_FRONTEND noninteractive

# Install systems
RUN apt-get -y update && \
    apt-get -y install \
      apt-utils \
      build-essential \
      curl \
      git

# Install node.js
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get -y install nodejs

# Install grunt
RUN npm install -g grunt-cli

# Install reveal.js
RUN git clone https://github.com/hakimel/reveal.js.git && cd reveal.js && npm install
RUN rm /reveal.js/index.html && ln -s /slides/index.html /reveal.js/index.html
COPY Gruntfile.js /reveal.js/

# Pandoc is looking for ...
# http://localhost:8000/reveal.js/css/reveal.min.css
# http://localhost:8000/reveal.js/js/reveal.min.js
# http://localhost:8000/reveal.js/lib/js/head.min.js
# http://localhost:8000/reveal.js/css/print/pdf.css
# http://localhost:8000/reveal.js/css/theme/simple.css
# http://localhost:35729/livereload.js?snipver=1
# http://localhost:8000/reveal.js/css/theme/simple.css
# http://localhost:8000/reveal.js/css/print/pdf.css
# http://localhost:8000/reveal.js/plugin/zoom-js

RUN mkdir -p /pandoc/reveal.js/css/lib /pandoc/reveal.js/js /pandoc/reveal.js/lib/js /pandoc/reveal.js/css/print
RUN ln -s /reveal.js/css/reveal.css /pandoc/reveal.js/css/reveal.min.css && \
    ln -s /reveal.js/js/reveal.js /pandoc/reveal.js/js/reveal.min.js && \
    ln -s /reveal.js/lib/js/head.min.js /pandoc/reveal.js/lib/js/head.min.js && \
    ln -s /reveal.js/css/print/pdf.css /pandoc/reveal.js/css/print/pdf.css && \
    ln -s /reveal.js/css/theme/ /pandoc/reveal.js/css/theme && \
    ln -s /reveal.js/plugin /pandoc/reveal.js/plugin

RUN apt-get -y install pandoc && \
    apt-get -y autoremove && \
    apt-get -y autoclean

WORKDIR reveal.js
CMD grunt serve

