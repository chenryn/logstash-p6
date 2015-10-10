#!/usr/bin/env perl6-m
use v6;
use lib 'lib';
use Test;

my $className = "LogStash::Input::Stdin";
require ::($className);
my $obj = ::($className).new(tags => ['tag1']);
$obj.register();
isa-ok($obj, $className);

my $supply = Supply.new;
my $s = start {
    loop {
        earliest $supply.Channel {
            more * -> $e {
                isa-ok($e, 'LogStash::Event', 'got a event');
                ok($e{'host'}:exists, 'event has host from BUILD');
                ok($e{'message'}:exists, 'event has message from STDIN');
                is($e{'type'}, 'logs', 'event has logs type from base');
                is($e{'tags'}[0], 'tag1', 'event has tags from itself');
                done-testing();
                exit;
            }
        }
    }
};
$obj.run($supply);

await $s;
