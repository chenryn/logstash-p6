#!/usr/bin/env perl6-m
use v6;
use LogStash::Codec::Base;
use LogStash::Event;
class LogStash::Codec::Line does LogStash::Codec::Base {
    method register () { }
    method encode ( LogStash::Event $event ) {
        &.on_event.($event.Str);
    }
    method decode ( $data ) {
        $data.lines.map: { LogStash::Event.new((message => $_)) }
    }
}
# vim:filetype=perl6
