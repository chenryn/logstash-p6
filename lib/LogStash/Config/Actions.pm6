#!/usr/bin/env perl6-m
use v6;

class LogStash::Config::Actions {

    method TOP($/)      {
        my %hash := { inputs => $<inputs>.made, outputs => $<outputs>.made };
        push(%hash, { filters => $<filters>.made }) if !!$<filters>.made;
        make %hash;
    }
    method inputs($/)   { make $<inputlist>.made.item }
    method filters($/)  { make $<filterlist>.made.item }
    method outputs($/)  { make $<outputlist>.made.item }
    
    method inputlist($/)   { make [$<plugin>.map(*.made)] }
    method filterlist($/)  { make [$<plugin>.map(*.made)] }
    method outputlist($/)  { make [$<plugin>.map(*.made)] }
    
    method plugin($/)  { make $<name>.made => $<pairs>.made.hash }
    method name($/)    { make $/.Str }
    method pairs($/)   { make $<pair>>>.made }
    method pair($/)    { make $<key>.made => $<value>.made }

    method key:sym<option>($/) { make $/.Str }
    method key:sym<string>($/) { make $<string>.Str.substr(1, *-1) }

    method value:sym<number>($/) { make +$/.Str }
    method value:sym<string>($/) { make $<string>.made }
    method value:sym<true>($/)   { make Bool::True  }
    method value:sym<false>($/)  { make Bool::False }
    method value:sym<array>($/)  { make $<array>.made  }
    method value:sym<hash>($/)   { make $<pairs>.made.hash.item }
    method value:sym<codec>($/)  { make $<plugin>.made }
    
    method array($/)     { make $<arraylist>.made.item }
    method arraylist($/) { make [$<value>.map(*.made)] }

    method string($/) {
        make +@$<str> == 1
            ?? $<str>[0].made
            !! $<str>>>.made.join;
    }
    method str($/)    { make ~$/ }

    my %h = '\\' => "\\",
            '/'  => "/",
            'b'  => "\b",
            'n'  => "\n",
            't'  => "\t",
            'f'  => "\f",
            'r'  => "\r",
            '"'  => "\"";
    method str_escape($/) {
        if $<utf16_codepoint> {
            make utf16.new( $<utf16_codepoint>.map({:16(~$_)}) ).decode();
        } else {
            make %h{~$/};
        }
    }

}
