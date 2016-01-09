#!/usr/bin/env perl
#use warnings;
use strict;
#use diagnostics;
use Term::ANSIColor;
use Data::Dumper;

# Identify functions as C
sub LCSLength;
sub printDiff(\@\@\@$$);
sub themax;
sub realPrint;
sub difference;

# Global Variables and Setups
my $numArgs = $#ARGV + 1;
my ($lines1, $lines2, $words1, $words2, $characters1, $characters2);
my (@aa1, @aa2, @aa12) = ();
($aa1[0], $aa2[0]) = " ";

# Ref: http://en.wikipedia.org/wiki/Longest_common_subsequence_problem#Computing_the_length_of_the_LCS
sub LCSLength
{
    my @X = $_[0];
    my @Y = $_[1];
    my $m = $_[2]; 
    my $n = $_[3]; 
    my @c = ();
    
    for (my $i = 0; $i <= $m; $i++)
    {
        $c[$i][0] = 0;
    }
    
    for (my $j = 0; $j<= $n; $j++)
    {
        $c[0][$j] = 0;
    }

    for (my $i = 1; $i < $m; $i++)
    {
        
        for (my $j = 1; $j < $n; $j++)
        {
    
            if (@{$X[0]}[$i] eq @{$Y[0]}[$j])
            {
                $c[$i][$j] = ($c[$i-1][$j-1]) +1;
            }
            
            else
            {
                $c[$i][$j] = themax($c[$i][$j-1], $c[$i-1][$j]);
            }
        }
    }

    return @c;     
}

# Pseudocode http://en.wikipedia.org/wiki/Longest_common_subsequence_problem#Print_the_diff
sub printDiff(\@\@\@$$) 
{       
    # Dereferencing http://perlmeme.org/howtos/using_perl/dereferencing.html
    my ($ref1, $ref2, $ref3, $i, $j) = @_;
    my @c = @$ref1;
    my @X = @$ref2;
    my @Y = @$ref3;
        if ($i > 0 and $j > 0  and ($X[$i] eq $Y[$j]))
        {
            printDiff(@c, @X, @Y, $i-1, $j-1);
            # All Push attempts too be used to sort in realPrint()
            push(@aa12, "$i * $X[$i]");
        }
        elsif($j > 0 and ($i == 0 or $c[$i][$j-1] ge  $c[$i-1][$j]))
        {
            printDiff(@c, @X, @Y, $i, $j-1);
            # All Push attempts too be used to sort in realPrint()
            push(@aa12, "$j + $Y[$j]");
        }
        elsif ($i > 0 and ($j == 0 or $c[$i][$j-1] < $c[$i-1][$j]))
        {
                
            printDiff(@c, @X, @Y, $i-1, $j);
            # All Push attempts too be used to sort in realPrint()
            push(@aa12, "$i - $X[$i]");
        }
        else
        {
            #
        }

    #print $aa12[1];
}

# Created a difference function to do the calculation. As partA.pl
sub difference
{
    my $first = $_[0];
    my $second = $_[1];
    my $total = (($first/$second) * 100 - 100);
    return $total;
}

# The Program starts here.
if ($numArgs != 2) {
    print "Please use two valid files\n";
    exit;
}
else{
    # Open and Test if the files exist
    open(my $FILE1, "$ARGV[0]") or die "$ARGV[0] cannot be opned please try again \n";
    open(my $FILE2, "$ARGV[1]") or die "$ARGV[1] cannot be opned please try again \n";
    
    print("\nAssignment 1 Perl - Part B\n");
    print("Text File Comparer Report\n");
    print("**************************\n");
    print("The two files are valid.\n\n");
    
    # Bug 003 - Without adding "" it spits out problems by simply adding "" to position 0 fixes it
    # during lab session
    ($aa1[0], $aa2[0]) = " ";
    
    # Adding each line from file 1 to @aa1 and pushing it to the end. Here I can use regex to modify lines
    # for Part C
    while (<$FILE1>)
    {
        $lines1++;
        $words1 += split(/\W+/, $_);
        $characters1 += length($_);
        s/(?!<|>)[[:punct:]]//g; # http://perldoc.perl.org/perlreref.html
        s/<.+?>//g; #http://stackoverflow.com/questions/15255709/r-regex-remove-all-punctuation-except-apostrophe
        push(@aa1, $_);
        $_ = lc for @aa1;
	}
	# Adding each line from file 2 to @aa2 and pushing it to the end. Here I can use regex to modify lines
    # for Part C
	while (<$FILE2>) 
	{
	    $lines2++;
	    $words2 += split(/\W+/, $_);
	    $characters2 += length($_);
	    s/(?!<|>)[[:punct:]]//g; #http://perldoc.perl.org/perlreref.html
	    s/<.+?>//g; # http://stackoverflow.com/questions/15255709/r-regex-remove-all-punctuation-except-apostrophe
	    push(@aa2, $_);
	    $_ = lc for @aa2;
	}
	
	# Bug 002 - Need to fix after using <$FILE1 and 2> cannot be used again till closed.
	close $FILE1;
    close $FILE2;
    
    # Sending the above var's to the difference function.
    my $linediff = sprintf("%1d",difference($lines1,$lines2));
    my $worddiff = sprintf("%1d",difference($words1,$words2));
    my $chardiff = sprintf("%1d",difference($characters1,$characters2));
    
    # Printing format.
    print("\t\t$ARGV[0]\t\t$ARGV[1]\tDifference(estimate)\n");
    print("-----------------------------------------------------------------------\n");
    print("Lines\t\t$lines1\t\t\t$lines2\t\t" . $linediff. "%\n");
    print("Words\t\t$words1\t\t\t$words2\t\t". $worddiff. "%\n");
    print("Characters\t$characters1\t\t\t$characters2\t\t". $chardiff. "%\n\n");

    # Creating i and j length of the arrays so I can use it for printDiff.
    # Originally they were in LCSLength but bringing them back out for PrintDiff were problems.
    my $i = scalar(@aa1)-1;
    my $j = scalar(@aa2)-1;
    
    # Calling LCSLength and returning to @c as matrix
    my @c = LCSLength(\@aa1, \@aa2, $i, $j);

    # Calling printDiff to print out differences + - and *
    printDiff(@c, @aa1, @aa2, $i, $j);
    
    # Using the + - * to try group them for distiguishing blocks of lines (In Progress)
    realPrint();
}

# Not sure if we could use max/min modules So I used exsiting ones.
# Ref: http://www.perlmonks.org/?node_id=406883
sub themax {
            my ($maximum, @vars) = @_;
            for (@vars) {
                $maximum = $_ if $_ > $maximum;
            }
            return $maximum;
        }
        
# A print function to try group blocks of code for close to diff output..
sub realPrint
{
    foreach my $line2(@aa12)
    {
        if ($line2 =~ m/^\d+\s[-|+]/)
        {
            print "Change $line2";
        }
        
        # if ($line2 =~ m/^\d+\s[+]/)
        # {
        #     print " $line2";
        # }
    }
    #print Dumper @aa12;
}

=pod
 
=head1 Assignment 1 - ParC.pl
 
partC.pl -  Advanced Text File Comparer
 
=head1 SYNOPSIS
 
=over 4
 
=item (1)
 
perl partC.pl [original_file] [modified_file]
 
=item (2)
 
./partC.pl [original_file] [modified_file]
 
=back
 
 
=head1 DESCRIPTION
 
B<partC.pl> is very similar to the perl script partB.pl that outputs the number of lines words 
and characters of each file without using external commands like WC and Diff.
It now doesn't care about case sensitive and removes punctuation and HTML tags.
 
=over 4
 
=item (1) OPTIONS
 
=over 4
 
=item original_file
 
The original file that you want to use to compare with another file.
 
=item modified_file
 
The file you want to compare the differences of the frist original file

=back
 
=item (2) sub difference -
 
The sub B<difference> is really simple formula to return the difference of two ints.

C<(($first/$second) * 100 - 100)>

=item (3) LCSLength -

This function was taken from Pseudo code from the wiki webpage:
http://en.wikipedia.org/wiki/Longest_common_subsequence_problem#Computing_the_length_of_the_LCS
LCSLenth we take in X and Y which are File 1 and File 2 contents and M and N
are the length of those files respectively. This function seems to create a matrix
as stated on the site surrouned by 0's and starts to fill in. It is all stored in @c
and is then returned to be used in printDiff().

=item (4) printDiff -

This function was taken from Pseudo code from the wiki webpage: 
http://en.wikipedia.org/wiki/Longest_common_subsequence_problem#Print_the_diff
In this function we take in 5 arguments as ref and start to compute through the
matrix length we created with LCSLength function. I have added push to be able to
use the array out of printDiff so I can create realDiff function to have attempt
to sort out the print in blocks of code to try replicate diff. printDiff has no
returns.

=item (5) themax -

This function instead of using any modules was helped creating simple max:
http://www.perlmonks.org/?node_id=406883
This is a simple function that accepts 2 arguments and just returns the larger
value back to the caller.

=item (6) realPrint -

This function is an attempt to sort the printDiff pushed @aa12 array into 
blocks of output so it can be easily read on what lines belong to which files.

=item (7) The Main Program

=over 4

=item $numArgs and opening file -

This if statement will check that the user has at least added 2 arguments, no more
and no less, if it does it will give an error. If there are two arguments it will
continue and attempt to open the two files, yet again if they do not exist or not
able to open for reading it will exit and issue a error.

=item WC Report -

This section of the program I have setup that 2 arrays very first position to be "".
By not doing this I have run into issues which I still need to figure out as a bug.
I have created a while loop for each file to round up the data of lines words and characters
then to push them into an array to be used in printDiff(). We do this for both files
then as we did in partA we send lines words and characters to the difference function 
for it to be used when we print out the WC report table. Extra steps are needed
here during the WC process to comply with partC requirements, we strip out all 
punctuations not including < and > since we need to use regex to find HTML tags
that start and with < > to identify the HTML tags. That is what we do in the second
round of striping. At the very end we also lower case all strings so that we can
match Hello and hello as one.


=item Diff Report -

Firstly I had issues with i and j (or M and N / length of file 1 and file 2)
when they were located into LCSLength so I have placed them outside. We call 
LCSLength() with 4 paramaters first two are File 1 and File 2 that we pushed in
the while loop above. then the next two are the size of file 1 and file 2. When it
returns it assigns the matrix to @c array. Then you call the printDiff() with 5
paramaters. first be the matrix, file 1 pushed array, file 2 pushed array and the
size of the two arrays. No var's get returned at this stage, all that is left
is to call the realPrint() function that attempts to print out the diff in 
better format.

=back

=back 


=head1 I<EXAMPLE>
 
Suppose the script is executable in the current path:
 
perl partA.pl original.pl modified.py

WC: Will print a table.

Diff: Will print out lines from the first file that needs to be (Deleted/Added/Changed)
in order to match the second file including the line content.

=begin man

                original.txt            modified.txt    Difference(estimate)
-----------------------------------------------------------------------
Lines           192                     183             4.92%
Words           1320                    1293            2.09%
Characters      8904                    8628            3.20% 

=end man
 
=head1 I<NOTES>
 
=begin html
 
File Version: <font size =4 color="#FF3300"> v7.0</font>
 
=end html

=head3 I<--BUGS>
 
=over 4

=item C<Known Bugs>

C<#001 - Just showing change and not add or delete text>

C<#002 - The use of using close files twice>

C<#003 - Adding "" to position 0 in array fixes issue>

=back 


Please report bugs s3435996@student.rmit.edu.au.

 
=head3 I<--AUTHOR>
 
Saso Petrovski S3435996
 
 
=head3 I<--LICENSE>
 
Copyright (c) 2015 by Saso Petrovski.
 
=over 4
 
=item 1.
 
Nothing is guaranteed to work.
 
=item 2.
 
Feel free to modify the code as long as you do not make it worse.
 
 
This notice must not be removed or altered.
 
=back
 
Thanks for your time.
 
=cut