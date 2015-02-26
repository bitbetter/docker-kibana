FROM dockerfile/ubuntu
MAINTAINER Martin Kretz <martin.kretz@bitbetter.se>

# Install kibana
WORKDIR /tmp
RUN wget --no-check-certificate -qO- https://download.elasticsearch.org/kibana/kibana/kibana-4.0.0-linux-x64.tar.gz | tar xvfz -
RUN mv kibana-4.0.0-linux-x64 /usr/share/kibana
RUN sed -i -e "s/^elasticsearch_url:.*/elasticsearch_url: \"http:\/\/elasticsearch:9200\"/" /usr/share/kibana/config/kibana.yml

# Install supervisor
RUN apt-get -q update
RUN apt-get -y install supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV KIBANA_USER kibana
ENV KIBANA_PASSWORD kibana

# Expose ports
EXPOSE 5601

# Run supervisor
WORKDIR /tmp
CMD ["/usr/bin/supervisord", "--configuration=/etc/supervisor/conf.d/supervisord.conf"]
