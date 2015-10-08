#!/usr/bin/env perl6-m
use v6;
use LogStash::Output::Base;
class LogStash::Output::Stdout does LogStash::Output::Base {
    method register () { }
    method receive ( $event ) {
        return unless $.is_output($event);
        say $event;
    }
}
# set filetype=perl6
