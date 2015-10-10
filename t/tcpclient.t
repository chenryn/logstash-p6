#!/usr/bin/env perl6-m
use v6;
use lib 'lib';
use Test;
use LogStash::Event;

my $className = "LogStash::Output::Tcp";
require ::($className);
my $obj = ::($className).new(host => '127.0.0.1', port => 3333);
isa-ok($obj, $className);
$obj.register();

my $server = IO::Socket::Async.listen('127.0.0.1', 3333);
my $tcpserver = $server.tap(-> $c {
    $c.chars-supply.tap(-> $chars {
            isa-ok($chars, Str, 'server receive string');
            like($chars, /^\@version\s+1/, 'event sent as Str');
            $c.close;
    }, quit => { say $_; });
});

my $event = LogStash::Event.new;
$obj.receive($event);
$tcpserver.close;

done-testing();
