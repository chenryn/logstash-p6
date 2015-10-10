#!/usr/bin/env perl6-m
use v6;
use lib 'lib';
use Test;

my $className = "LogStash::Codec::Json";
require ::($className);
my $obj = ::($className).new;
isa-ok($obj, $className);

my $hash_string = '{"key":"value"}';
my $event1 = $obj.decode($hash_string);
isa-ok($event1, "LogStash::Event");
is($event1{'key'}, "value", 'set a right field');
for @($event1) -> $e {
    isa-ok($e, "LogStash::Event");
    is($e{'key'}, "value", 'hash event can used in for loop too.');
}

my $array_string = '[{"key":"value"}]';
my $event2 = $obj.decode($array_string);
for @($event2) -> $e {
    isa-ok($e, "LogStash::Event");
    is($e{'key'}, "value", 'set a right field in array');
}

my $nonjson_string = 'test';
my $event3 = $obj.decode($nonjson_string);
isa-ok($event3, "LogStash::Event");
is($event3{'tags'}, ["_jsonparsefailure"], 'set a failure tag');

done-testing();
