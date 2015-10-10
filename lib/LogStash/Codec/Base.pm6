#!/usr/bin/env perl6-m
use v6;
role LogStash::Codec::Base {
    has &.on_event is rw;
    method register () { ... }
    method encode ( $event ) { ... }
    method decode ( $data ) { ... }
}
# vim:filetype=perl6
