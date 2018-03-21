FROM phusion/passenger-ruby18

WORKDIR /home/app
ENV HOME /home/app

RUN apt-get update; \
    apt-get install --force-yes -y libpq-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /etc/nginx/sites-enabled/default && \
    rm -f /etc/service/nginx/down

COPY Gemfile Gemfile.lock /home/app/
RUN  bundle install

COPY . /home/app
COPY ./config/webapp.conf /etc/nginx/sites-enabled/webapp.conf

RUN mkdir -p $HOME/logs && \
    mkdir -p $HOME/tmp && \
    chown app.app $HOME -R

CMD ["/sbin/my_init"]
