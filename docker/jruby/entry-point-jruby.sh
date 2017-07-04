#!/bin/bash

java -Xmx32m -version
ruby --version

bundle --version
gem --version

cd /app

bundle exec appraisal rails-4-2 rake
