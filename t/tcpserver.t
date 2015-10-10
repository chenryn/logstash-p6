#!/usr/bin/env perl6-m
use v6;
use lib 'lib';
use Test;

my $className = "LogStash::Input::Tcp";
require ::($className);
my $obj = ::($className).new(host => '127.0.0.1', port => 3333);
isa-ok($obj, $className);
$obj.register();

my $supply = Supply.new;
$supply.tap: -> $e {
    isa-ok($e, 'LogStash::Event', 'got a event');
    ok($e{'host'}:exists, 'event has host from BUILD');
    ok($e{'message'}:exists, 'event has message from STDIN');
    is($e{'type'}, 'logs', 'event has logs type from base');
    done-testing();
    exit;
};

$obj.run($supply);
