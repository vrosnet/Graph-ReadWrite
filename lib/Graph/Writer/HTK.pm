#
# Graph::Writer::HTK - perl module for writing a Graph as an HTK lattice
#
# $Id: HTK.pm,v 1.2 2001/11/11 14:24:37 neilb Exp $
#
package Graph::Writer::HTK;

#=======================================================================
#=======================================================================

use Graph::Writer;
use vars qw(@ISA $VERSION);
@ISA = qw(Graph::Writer);
$VERSION = sprintf("%d.%02d", q$Revision: 1.2 $ =~ /(\d+)\.(\d+)/);

my @graph_attributes = qw(base lmname lmscale wdpenalty);

my %node_attributes =
(
    'W' => [ 'WORD', 'label' ],
    't' => [ 'time' ],
    'v' => [ 'var' ],
    'L' => [ 'L' ],
);

my %edge_attributes =
(
    'W' => [ 'WORD', 'label' ],
    'v' => [ 'var' ],
    'd' => [ 'div' ],
    'a' => [ 'acoustic' ],
    'n' => [ 'ngram' ],
    'l' => [ 'language', 'weight' ],
);

#=======================================================================
#
# _write_graph
#
# dump the graph out as an HTK lattice to the given filehandle.
#
#=======================================================================
sub _write_graph
{
    my $self  = shift;
    my $graph = shift;
    my $FILE  = shift;

    my $nvertices;
    my $nedges;
    my $v;
    my $from;
    my $to;
    my %v2n;
    my $node_num;
    my $edge_num;


    print $FILE "VERSION=1.0\n";
    print $FILE "N=",int($graph->vertices),"  L=",int($graph->edges),"\n";

    $node_num = 0;
    foreach $v ($graph->vertices)
    {
	$v2n{$v} = $node_num;
	print $FILE "I=$node_num";
	foreach my $field (keys %node_attributes)
	{
	    foreach my $attr (@{ $node_attributes{$field} })
	    {
		if ($graph->has_attribute($attr, $v))
		{
		    print $FILE "  $field=", $graph->get_attribute($attr, $v);
		    last;
		}
	    }
	}
	print $FILE "\n";
	++$node_num;
    }

    $edge_num = 0;
    my @edges = $graph->edges;
    while (@edges > 0)
    {
	($from, $to) = splice(@edges, 0, 2);
	print $FILE "J=$edge_num  S=", $v2n{$from}, "  E=", $v2n{$to};
	foreach my $field (keys %edge_attributes)
	{
	    foreach my $attr (@{ $edge_attributes{$field} })
	    {
		if ($graph->has_attribute($attr, $from, $to))
		{
		    print $FILE "  $field=",
				$graph->get_attribute($attr, $from, $to);
		    last;
		}
	    }
	}
	print $FILE "\n";
	++$edge_num;
    }

    return 1;
}

1;

__END__

=head1 NAME

Graph::Writer::HTK - write an perl Graph out as an HTK lattice file

=head1 SYNOPSIS

    use Graph::Writer::HTK;
    
    $writer = Graph::Reader::HTK->new();
    $reader->write_graph($graph, 'mylattice.lat');

=head1 DESCRIPTION

=head1 SEE ALSO

=over 4

=item Graph

Jarkko Hietaniemi's Graph class and others, used for representing
and manipulating directed graphs. Available from CPAN.
Also described / used in the chapter on directed graph algorithms
in the B<Algorithms in Perl> book from O'Reilly.

=item Graph::Writer

The base-class for this module, which defines the public methods,
and describes the ideas behind Graph reader and writer modules.

=item Graph::Reader::HTK

A class which will read a perl Graph from an HTK lattice file.

=back

=head1 AUTHOR

Neil Bowers E<lt>neil@bowers.comE<gt>

=head1 COPYRIGHT

Copyright (c) 2000, Neil Bowers. All rights reserved.
Copyright (c) 2000, Canon Research Centre Europe. All rights reserved.

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

