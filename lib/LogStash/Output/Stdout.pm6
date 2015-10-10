#!/usr/bin/env perl6-m
use v6;
use LogStash::Output::Base;
class LogStash::Output::Stdout does LogStash::Output::Base {
    method register {
        $.codec.on_event = sub ($event) {
            say $event;
        };
    }
    method receive ( $event ) {
        return unless $.is_output($event);
        $.codec.encode($event);
    }
}
# set filetype=perl6
