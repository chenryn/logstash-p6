#!/usr/bin/env perl6-m
use v6;
role LogStash::Filter::Base {
    has Str $.type;
    has @.tags;
    has @.remove_tag;
    has @.add_tag;
    has @.remove_field;
    has %.add_field;
    method register () { ... }
    method filter ( $event ) { ... }
    method filter_matched ($event) {
        push($event, %.add_field);
        for @.remove_field -> $field {
            $event{$field}:delete;
        }
        $event{'tags'}.push(@.add_tag);
        for @.remove_tag -> $tag {
            my $i = $event{'tags'}.index($tag);
            $event{'tags'}[$i]:delete;
        }
    }
    method is_filter ( $event ) {
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
# set filetype=perl6
