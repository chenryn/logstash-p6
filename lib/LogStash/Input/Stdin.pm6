#!/usr/bin/env perl6-m
use v6;
use LogStash::Input::Base;
use LogStash::Event;
class LogStash::Input::Stdin does LogStash::Input::Base {
    has $!hostname;
    submethod DESTROY {
        say "undefine now";
    }
    method register {
        $!hostname = qqx{hostname};
    }
    method run(Supply $supply) {
        for lines() {
            my %h = host => $!hostname, message => $_, type => $.type;
            my $event = LogStash::Event.new(%h);
            $.decorate($event);
            $supply.emit($event);
        }
    }
}
# set filetype=perl6
