#!/usr/bin/env perl6-m
use v6;
use LogStash::Codec::Line;
role LogStash::Output::Base {
    has Str $.type;
    has $.codec is rw = LogStash::Codec::Line.new;
    has @.tags;
    method register () { ... }
    method receive ( $event ) { ... }
    method is_output ( $event ) {
        if !!$.type {
            if $event{'type'} ne $.type {
                return False;
            }
        }
        if !!@.tags {
            if !@.tags.index(all($event{'tag'})) {
                return False;
            }
        }
        return True;
    }
}
# vim:filetype=perl6
