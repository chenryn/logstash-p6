#!/usr/bin/env perl6-m
use v6;
use JSON::Fast;
#|{use subscript to build a event like hash}
class LogStash::Event does Iterable does Associative {
    has %!fields handles <AT-KEY EXISTS-KEY DELETE-KEY Str push kv keys values>;

    method new (%args={}) {
        return self.bless(*, :fields(%args));
    }

    submethod BUILD (:%!fields) {
        if %!fields{'@timestamp'}:exists {
            %!fields{'@timestamp'} = DateTime.new(%!fields{'@timestamp'});
        } else {
            %!fields{'@timestamp'} = DateTime.now;
        }
        %!fields{'@version'} //= 1;
    }

    method iterator() { %!fields.keys.iterator }
    method to-json() {
        my %json = %!fields;
        %json{'@timestamp'} = %!fields{'@timestamp'}.Str;
        to-json(%json, pretty => False)
    }

}
