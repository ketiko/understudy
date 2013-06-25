# Understudy

[![Gem Version](https://badge.fury.io/rb/understudy.png)](http://badge.fury.io/rb/understudy)
[![Build Status](https://travis-ci.org/ketiko/understudy.png?branch=master)](https://travis-ci.org/ketiko/understudy)
[![Dependency Status](https://gemnasium.com/ketiko/understudy.png)](https://gemnasium.com/ketiko/understudy)
[![Code Climate](https://codeclimate.com/github/ketiko/understudy.png)](https://codeclimate.com/github/ketiko/understudy)
[![Coverage Status](https://coveralls.io/repos/ketiko/understudy/badge.png?branch=master)](https://coveralls.io/r/ketiko/understudy?branch=master)

Automated system backups via rdiff-backup

* [Source Code](http://github.com/ketiko/understudy)
* [API documentation](http://rubydoc.info/github/ketiko/understudy/master)
* [Rubygem](http://rubygems.org/gems/understudy)

Understudy fills in for you when you need them the most, when you lose your data.  It knows every line and is ready to step in whenever you need it.

Understudy automates entire system backups using rdiff-backup internally.  It's based on automated rdiff-backup configurations I've found myself setting up over and over.
I wanted to simplify some of the rdiff-backup process by enabling some defaults based on the path.  I also wanted to be able easily backup an entire machine without worrying about
multiple rdiff-backup scripts.

## Installation

$ gem install understudy

## Usage

$ understudy --help

## License

Released under the MIT License.  See the [LICENSE][] file for further details.

[license]: LICENSE.txt
