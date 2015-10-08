#!/usr/bin/env perl6-m
use v6;
use Test;
use lib './lib';
use LogStash::Config::Grammar;
use LogStash::Config::Actions;

my $grammar = LogStash::Config::Grammar.new;
my $actions = LogStash::Config::Actions.new;
isa-ok($grammar, LogStash::Config::Grammar);
isa-ok($actions, LogStash::Config::Actions);

my $text = q:to"EOI";
input {
  file {
    path => [ "/var/log/message" ]
  }
  stdin {}
}
filter {
  grok {
    match => {
      "message" => "%{ACCESSLOG}"
      "host" => "%{IDC}"
    }
    remove_fields => [ "message", "host" ]
  }
  date {
    match => { "date" => "UNIX_MS" }
  }
}
output {
  elasticsearch {
    index => "logstash-%{+YYYY.MM.DD}"
    cluster => "es1003"
    flush_size => 1000
  }
  stdout { codec => rubydebug {} }
}
EOI

my $ret = $grammar.parse($text,:actions($actions)).made;
my %exp = (
    inputs => [
        file => { path => ["/var/log/message"] },
        stdin => {}
    ],
    filters => [
        grok => { match => {host => "\%\{IDC}", message => "\%\{ACCESSLOG}"}, remove_fields => ["message", "host"] },
        date => { match => {date => "UNIX_MS"} }
    ],
    outputs => [
        elasticsearch => {
            cluster => "es1003",
            flush_size => 1000,
            index => "logstash-\%\{+YYYY.MM.DD}"
        }, 
        stdout => {codec => ( rubydebug => {} ) }
    ]
);
is-deeply($ret, %exp, "config parse");

done-testing();
# vim:filetype=perl6
