#!/usr/bin/env factor

USING: kernel io io.files io.encodings.utf8
math.parser math.ranges sequences sequences.private splitting math ;
IN: aoc

: read-input ( path -- seq )
    utf8 file-contents "\n" split [ string>number ] map ;

! Array mutations for part one and two
: inc ( seq1 i -- seq2 ) dupd swap [ 1 + ] change-nth ;
: dec ( seq1 i -- seq2 ) dupd swap [ 1 - ] change-nth ;
: mut-one ( j seq1 i -- seq2 j ) inc swap ;
: mut-two ( j seq1 i -- seq2 j ) 2dup swap array-nth 3 >= [ dec ] [ inc ] if swap ;
: inc-time ( t1 seq i -- t2 seq i ) rot 1 + rot rot ;

: done ( seq i -- seq i bool ) over length 1 - dupd >= over 0 < or ;
: jump ( seq i -- j seq i ) 2dup swap array-nth over + rot swapd swap ;

: solve-one ( t1 seq1 i -- t2 )
    [ done not ] [ inc-time jump mut-one ] while drop drop ;

: solve-two ( t1 seq1 i -- t2 )
    [ done not ] [ inc-time jump mut-two ] while drop drop ;

"input.txt" read-input 0 swap 0 solve-one number>string "Part one " print print
"input.txt" read-input 0 swap 0 solve-two number>string "Part two " print print
