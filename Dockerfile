# Use phusion/passenger-full as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/CHANGELOG.md for
# a list of version numbers.
FROM phusion/passenger-full:1.0.11
# Or, instead of the 'full' variant, use one of these:
#FROM phusion/passenger-ruby23:<VERSION>
#FROM phusion/passenger-ruby24:<VERSION>
#FROM phusion/passenger-ruby25:<VERSION>
#FROM phusion/passenger-ruby26:<VERSION>
#FROM phusion/passenger-jruby92:<VERSION>
#FROM phusion/passenger-nodejs:<VERSION>
#FROM phusion/passenger-customizable:<VERSION>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# If you're using the 'customizable' variant, you need to explicitly opt-in
# for features.
#
# N.B. these images are based on https://github.com/phusion/baseimage-docker,
# so anything it provides is also automatically on board in the images below
# (e.g. older versions of Ruby, Node, Python).
#
# Uncomment the features you want:
#
#   Ruby support
#RUN /pd_build/ruby-2.3.*.sh
#RUN /pd_build/ruby-2.4.*.sh
#RUN /pd_build/ruby-2.5.*.sh
#RUN /pd_build/ruby-2.6.*.sh
#RUN /pd_build/jruby-9.2.*.sh
#   Python support.
#RUN /pd_build/python.sh
#   Node.js and Meteor standalone support.
#   (not needed if you already have the above Ruby support)
#RUN /pd_build/nodejs.sh

RUN bash -lc 'rvm --default use ruby-2.6.6'

# ...put your own build instructions here...
RUN apt-get update && apt-get install -y tzdata
RUN gem install bundler:2.1.4
COPY --chown=app:app Gemfile Gemfile.lock /home/app/webapp/
WORKDIR /home/app/webapp
ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true
RUN bundle install --deployment --without development test
COPY --chown=app:app . /home/app/webapp
RUN rake assets:precompile
RUN chown -R app:app /home/app/webapp

# RUN mkdir /home/app/webapp/log \
#         && chown app:app /home/app/webapp/log \
#         && mkdir /home/app/webapp/tmp \
#         && chown app:app /home/app/webapp/tmp

# RUN chown -R app:app /home/app/webapp/log \
#         && chown -R app:app /home/app/webapp/tmp

RUN rm /etc/nginx/sites-enabled/default
ADD webapp.conf /etc/nginx/sites-enabled/webapp.conf
ADD neo4jenv.conf /etc/nginx/main.d/neo4jenv.conf

ENV NEO4J_TYPE bolt
# ENV NEO4J_URL "bolt://neo4j:clingen@tndeb:7687"

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /etc/service/nginx/down
