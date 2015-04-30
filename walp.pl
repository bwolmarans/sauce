

use feature qw(say);



$pool_members[0] = "Pool1";
$pool_members[1] = "Pool2";
$members[0][0] = member1;
$members[0][1] = member2;
$members[0][2] = member3;
$members[1][0] = member4;
$members[1][1] = member5;    
    
print $pool_members[1];

@coins = ("Quarter","Dime","Nickel");

# PRINT THE ARRAY
say "@coins";
say @coins;
say $coins[2];

my @stuff = (
['one', 'two', 'three', 'four'],
[7, 6, 5],
['apple', 'orange'],
[0.3, 'random', 'stuff', 'here', 5],
);

say $stuff[0][2];

say $stuff[3][1];


@AoA = (
[ "fred", "barney" ],
[ "george", "jane", "elroy" ],
[ "homer", "marge", "bart" ],
);

# print the whole thing with refs
for $aref ( @AoA ) {
	print "\t [ @$aref ],\n";
}


# print the whole thing with indices
for $i ( 0 .. $#AoA ) {
	print "\t [ @{$AoA[$i]} ],\n";
}


 # print the whole thing one at a time
 for $i ( 0 .. $#AoA ) {
     for $j ( 0 .. $#{ $AoA[$i] } ) {
         print "elt $i $j is $AoA[$i][$j]\n";
     }
 }
 
 
   my @array1 = (1, 2, 3, 'four');
     my $reference1 = \@array1;
     my @array2 = ('one', 'two', 'three', 4);
     my $reference2 = \@array2;
 
     my @array = ($reference1, $reference2);
 
     # this refers to the first item of the first array:
    print $array[1]->[2];

