#!/usr/bin/env perl 

use strict;
use warnings;
use Data::Dumper;

sub diff
{
    sub backtrack
    {
        print $_[3];
    }
    
    sub LCS{
    
        sub max {
            my ($max, @vars) = @_;
            for (@vars) {
                $max = $_ if $_ > $max;
            }
            return $max;
        }
       
        my @x = $_[0];
        my @y = $_[1];
        
        my $m = @{$x[0]};
        my $n = @{$y[0]}; 
        
        my @c = ();
        
        for (my $i = 0; $i<= $m; $i++)
        {
            $c[$i][0] = 0;
        }
        
         for (my $j = 0; $j<= $n; $j++)
        {
            $c[0][$j] = 0;
        }
        
        for (my $i = 1; $i <= $m; $i++)
        {
           
            for (my $j = 1; $j <= $n; $j++)
            {  
                my $firstnum = @{$_[0]}[$i-1];
                my $secondnum = @{$_[1]}[$j-1];
                
                if ($firstnum eq $secondnum)
                {   
                print "\nentered".$firstnum,$secondnum;
                    
                    $c[$i][$j] = ($c[$i-1][$j-1])+1;
                }
               
                else
                { 
                    $c[$i][$j] = max($c[$i][$j-1], $c[$i-1][$j]);
                }
            }
        }
        print Dumper @c;
    
        return $c[$m][$n];   
    }
    
    my @array1 = ["A", "B", "C", "D", "E"];
    my @array2 = ["A", "B", "C", "C", "E"];
    print LCS(@array1, @array2);
}


diff();