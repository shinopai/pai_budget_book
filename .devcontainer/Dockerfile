# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.9
FROM ghcr.io/rails/devcontainer/images/ruby:$RUBY_VERSION

# Install SSH client so git push via SSH works inside the Dev Container
USER root
RUN apt-get update -qq && \
  apt-get install -y --no-install-recommends openssh-client && \
  rm -rf /var/lib/apt/lists/*

# Return to the default non-root user provided by the base image
USER rails

# Ensure binding is always 0.0.0.0
# Binds the server to all IP addresses of the container, so it can be accessed from outside the container.
ENV BINDING="0.0.0.0"
