FROM ubuntu:16.10

MAINTAINER tuxflo

RUN apt-get update && apt-get -y install build-essential gcj-jdk unzip wget
RUN wget http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk-2.02-src.zip && unzip pdftk-2.02-src.zip
RUN sed -i 's/VERSUFF=-4.6/VERSUFF=-4.8/g' pdftk-2.02-dist/pdftk/Makefile.Debian
RUN cd pdftk-2.02-dist/pdftk && make -f Makefile.Debian && make -f Makefile.Debian install
RUN rm -rf pdftk-2.02-dist pdftk-2.02-src.zip && apt-get clean

RUN apt-get update && apt-get upgrade -y && apt-get install -y incron inotify-tools ocrmypdf tesseract-ocr tesseract-ocr-deu

ADD ./mergepdf.sh /opt/mergepdf.sh
RUN chmod a+x /opt/mergepdf.sh

RUN adduser --disabled-password --gecos '' r && adduser r sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN echo r >> /etc/incron.allow
USER r

RUN cd /home/r && incrontab -l > mycron && echo '/srv/input IN_CREATE /opt/mergepdf.sh $#' >> mycron && incrontab mycron && rm mycron
USER root
CMD ["/usr/sbin/incrond","-n"]
