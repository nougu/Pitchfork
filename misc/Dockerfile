FROM cloudgear/ruby:2.2-minimal

RUN \
  apt-get update -y -qq && \
  apt-get install -y -qq --no-install-recommends git-core dmsetup && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  truncate -s 0 /var/log/*log

RUN \
  git clone http://10.124.61.187:8080/git/PRO36/Pitchfork.git && \
  cd Pitchfork && \
  gem build pitchfork.gemspec && \
  gem install pitchfork-*.gem

VOLUME "/tmp"
VOLUME "/dev"

ENTRYPOINT ["/usr/local/bin/pf"]

