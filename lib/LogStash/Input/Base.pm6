#!/usr/bin/env perl6-m
use v6;
use LogStash::Codec::Line;
role LogStash::Input::Base {
    has Str $.type is rw = 'logs';
    has $.codec is rw = LogStash::Codec::Line.new;
    has @.tags;
    has %.add_field;
    method run () { ... }
    method register () { ... }
    method decorate ($event) {
        say $event.WHAT;
        $event{'type'} = $.type unless $event{'type'}:exists;
        push($event, %.add_field);
        $event{'tags'}.push(@.tags);
    }
}
# set filetype=perl6
