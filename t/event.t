#!/usr/bin/env perl6-m
use v6;
use Test;
use lib './lib';
use LogStash::Event;

my $e1 = LogStash::Event.new;
isa-ok($e1, LogStash::Event);

is( $e1{'@version'}, 1, 'event use version 1.');

my %h := { '@timestamp' => '2015-10-07T00:41:56Z', host => 'localhost' };
my $e2 = LogStash::Event.new(%h);

isa-ok($e2{'@timestamp'}, DateTime, '@timestamp need to be an object.');
is( $e2{'@timestamp'}, '2015-10-07T00:41:56Z', 'event had a old timestamp');
ok( $e2{'host'}:exists, 'yes, we can use adverb for LogStash::Event');

push($e2, {message => 'Hello World'});

my @exp = ['@timestamp', '@version', 'host', 'message'];
is-deeply($e2.keys.sort.Array, @exp, "fieldlist has message now");

done-testing();
# vim:filetype=perl6
