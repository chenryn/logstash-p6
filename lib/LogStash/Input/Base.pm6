#!/usr/bin/env perl6-m
use v6;
use LogStash::Event;
role LogStash::Input::Base {
    has Str $.type is rw = 'logs';
    has $.codec is rw = 'plain';
    has @.tags;
    has %.add_field;
    method run () { ... }
    method register () { ... }
    method decorate ($event) {
        push($event, %.add_field);
        $event{'tags'}.push(@.tags);
    }
}
# set filetype=perl6
