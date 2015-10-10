#!/usr/bin/env perl6-m
use v6;
use LogStash::Input::Base;
class LogStash::Input::Stdin does LogStash::Input::Base {
    has $!hostname;
    submethod DESTROY {
        say "undefine now";
    }
    method register {
        $!hostname = gethostname;
    }
    method run(Supply $supply) {
        for lines() {
            my $events = $.codec.decode($_);
            for @($events) -> $event {
                say $event;
                $.decorate($event);
                $event{'host'} = $!hostname unless $event{'host'}:exists;
                $supply.emit($event);
            }
        }
    }
}
# set filetype=perl6
