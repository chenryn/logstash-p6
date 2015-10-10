#!/usr/bin/env perl6-m
use v6;
use LogStash::Input::Base;
use LogStash::Event;
class LogStash::Input::Tcp does LogStash::Input::Base {
    has $.host is rw;
    has $.port is rw = 3333;
    has $!server;
    submethod DESTROY {
        say "undefine now";
    }
    method register {
        $.host //= gethostname;
        $!server = IO::Socket::Async.listen($.host, $.port);
    }
    method run(Supply $supply) {
        react {
            whenever $!server -> $conn {
                my $cs = $conn.chars-supply;
                $cs.tap(-> $char {
                    my $events = $.codec.decode($char);
                    for @($events) -> $event {
                        $.decorate($event);
                        $event{'host'} = $.host unless $event{'host'}:exists;
                        $supply.emit($event);
                    }
                });
                $cs.wait;
                $conn.close;
            }
        }
    }
}
# set filetype=perl6
