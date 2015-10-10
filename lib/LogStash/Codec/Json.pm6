#!/usr/bin/env perl6-m
use v6;
use LogStash::Codec::Base;
use LogStash::Event;
use JSON::Fast;
class LogStash::Codec::Json does LogStash::Codec::Base {
    method register () { }
    method encode ( LogStash::Event $event ) {
        &.on_event.(to-json($event));
    }
    method decode ( $data ) {
        my $json = from-json($data);
        CATCH {
            my %fail = (message => $data, tags => ['_jsonparsefailure']);
            return LogStash::Event.new(%fail)
        }
        if $json ~~ Hash {
            return LogStash::Event.new($json)
        } else {
            $json.map: { LogStash::Event.new($_) }
        }
    }
}
# vim:filetype=perl6
