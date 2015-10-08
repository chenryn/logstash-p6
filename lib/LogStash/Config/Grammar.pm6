#!/usr/bin/env perl6-m
use v6;

grammar LogStash::Config::Grammar {

    rule TOP     { ^ \s* <inputs> <filters>? <outputs> \s* $ }
    rule inputs  { 'input' '{' ~ '}' <inputlist> }
    rule filters { 'filter' '{' ~ '}' <filterlist> }
    rule outputs { 'output' '{' ~ '}' <outputlist> }
    
    rule inputlist  { <plugin>+ }
    rule filterlist { <plugin>* }
    rule outputlist { <plugin>+ }
    
    rule plugin  { <name> '{' ~ '}' <pairs> }
    token name   { \w+ }
    rule pairs   { \s* <pair>* \s* }
    rule pair    { <key> '=>' <value> }

    proto token key {*};
    token key:sym<option> { \w+ }
    token key:sym<string> { <string> }
    
    proto token value {*};
    token value:sym<number> {
        '-'?
        [ 0 | <[1..9]> <[0..9]>* ]
        [ \. <[0..9]>+ ]?
        [ <[eE]> [\+|\-]? <[0..9]>+ ]?
    }
    token value:sym<true>   { <sym>    };
    token value:sym<false>  { <sym>    };
    token value:sym<codec>  { <plugin> };
    token value:sym<hash>   { '{' ~ '}' <pairs> };
    token value:sym<array>  { <array>  };
    token value:sym<string> { <string> }

    rule array     { '[' ~ ']' <arraylist> }
    rule arraylist { <value> * % \, }

    token string {
        \" ~ \" [ <str> | \\ <str=.str_escape> ]*
    }
    token str {
        <-["\\\t\n]>+
    }
    token str_escape {
        <["\\/bfnrt]> | 'u' <utf16_codepoint>+ % '\u'
    }
    token utf16_codepoint {
        <.xdigit>**4
    }

}

