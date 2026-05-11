# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.9
FROM ghcr.io/rails/devcontainer/images/ruby:$RUBY_VERSION

# Install additional packages required for development
USER root
RUN apt-get update -qq && \
  apt-get install -y --no-install-recommends \
  build-essential \
  git \
  openssh-client \
  curl \
  libpq-dev \
  postgresql-client && \
  rm -rf /var/lib/apt/lists/*

# Return to the default non-root user provided by the base image
USER vscode

# Ensure Rails server binds to all interfaces
ENV BINDING="0.0.0.0"
