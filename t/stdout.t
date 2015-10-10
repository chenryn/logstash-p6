#!/usr/bin/env perl6-m
use v6;
use lib 'lib';
use Test;
use LogStash::Event;
use LogStash::Codec::Json;

my $className = "LogStash::Output::Stdout";
require ::($className);
my $codec = LogStash::Codec::Json.new;
my $obj = ::($className).new(codec => $codec);
$obj.register();
isa-ok($obj, $className);

my $event = LogStash::Event.new(message => "stdout test");

my $stdout = $*OUT;
my $result;
$*OUT = class {
    method print(*@args) {
        $result ~= @args.join;
    }
    method flush {}
}
$obj.receive($event);

$*OUT = $stdout;
isa-ok($result, Str, 'capture a Str from $*OUT');
like($result, /^\{\"/, 'got a JSON like beginning');

done-testing();
