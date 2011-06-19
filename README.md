Guard::CoffeeDripper
====
Guard::CoffeeDripper is MargeTool for CoffeeScript

Install
----
Install the gem:

    gem install guard-coffeedripper

Add it to your Gemfile (inside test group):

    gem 'guard-coffeedripper'

Add coffeedripper definition to your Guardfile and config/coffee-dripper.yaml by running this command:

    guard init coffeedripper

Usage
----

Please read Guard usage doc
Guardfile for Rails3.0 and barista

    guard 'coffeedripper', :output => 'app/coffscripts/'  do
      watch(%r{^app/coffeescripts/(.+)\.bean$}) {|m| "#{m[1]}.bean"}
    end

or Rails3.1

    guard 'coffeedripper', :output => 'app/assets/javascripts/' do
      watch(%r{^app/assets/javascripts/(.+)\.bean$}) {|m| "#{m[1]}.bean"}
    end

config/coffee-dipper.yaml
    appplication.js.coffee:
      - hoge.bean
      - huga.bean

