#!/usr/bin/env perl 

use strict;
use warnings;
#use diagnostics;
use Data::Dumper;


sub diff
{
    sub printdiff (\@\@\@$$)
    {
        my ($ref1, $ref2, $ref3, $i, $j) = @_;
        my @c = @$ref1;
        my @X = @$ref2;
        my @Y = @$ref2;
        # my $i = $_[3];
        # my $j = $_[4];
        
        # print Dumper @X;
        # print $X[4];
        # print $Y[4];
        #print $Y[0][$j-1];
        #1
        if ($i>0 and $j>0 and ($X[$i-1] eq $Y[$j-1])) #@{$X[0]}[$i-1] eq @{$Y[0]}[$j-1])
        {
            printdiff(@c, @X, @Y, $i-1, $j-1);
        #     #print "  " . @{$X[0]}[$i-1];
        # }
        # elsif ($j>0 and ($i==0 or $c[$i][$j-1] >= $c[$i-1][$j]))
        # {
        #     #
        }
        #print Dumper @c;
        
        
        
        #print $i;
    }
    
    sub LCS{
    
        sub max {
            my ($max, @vars) = @_;
            for (@vars) {
                $max = $_ if $_ > $max;
            }
            return $max;
        }
        
        #(my @x, my @y) = @_; #Questionable?...trolol
        my @X = $_[0];
        my @Y = $_[1];
        
        my $m = @{$X[0]}; #$_[0]
        my $n = @{$X[0]}; #$_[1]
        
        
        my @c = ();
        # 1
        for (my $i = 0; $i <= $m; $i++)
        {
            $c[$i][0] = 0;
            #print "[$i] i \n";
        }
        # 2
         for (my $j = 0; $j<= $n; $j++)
        {
            $c[0][$j] = 0;
            #print "[$j] j \n";
        }
        #print @{[$_[0][1]]};
        #print Dumper @c;
        # 3
        #print "Hello5";
        for (my $i = 1; $i <= $m; $i++)
        {
            # 4
            #print "Hello4";
            for (my $j = 1; $j <= $n; $j++)
            {
                # 5
                #print "Hello3";

                if (@{$X[0]}[$i-1] eq @{$Y[0]}[$j-1])
                {
                    #print "Hello2";
                    $c[$i][$j] = ($c[$i-1][$j-1]) +1;
                    #print $c[$i][$j];
                }
                # 6
                else
                {
                    $c[$i][$j] = max($c[$i][$j-1], $c[$i-1][$j]);
                }
                #print "Hello6";
            }
            #print "Hello7";
        }

        #print Dumper @c;
        #print $c[$m][$n]
        return @c;
        #backtrack(@var, @array1, @array2, $m, $n)
        
    }
    
    my @array1 = ["A", "B", "C", "D", "E"];
    my @array2 = ["A", "B", "C", "C", "E"];
    my @c = LCS(@array1, @array2);
    my @a1 = ("A", "B", "C", "D", "E");
    my @a2 = ("A", "B", "C", "C", "E");
    my $i = scalar(@a1);
    my $j = scalar(@a2);
    #print Dumper @array2;
    
    
    printdiff(@c, @a1, @a2, $i, $j);

}


diff();