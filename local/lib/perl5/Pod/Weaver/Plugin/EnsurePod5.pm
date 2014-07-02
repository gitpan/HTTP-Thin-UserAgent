package Pod::Weaver::Plugin::EnsurePod5;
{
  $Pod::Weaver::Plugin::EnsurePod5::VERSION = '4.006';
}
use Moose;
with 'Pod::Weaver::Role::Preparer';
# ABSTRACT: ensure that the Pod5 translator has been run on this document

use namespace::autoclean;
use Moose::Autobox;

use Pod::Elemental::Transformer::Pod5;


sub _strip_nonpod {
  my ($self, $node) = @_;

  # XXX: This is really stupid. -- rjbs, 2009-10-24
  $node->children->keys->reverse->each_value(sub {
    my ($i, $para) = ($_, $node->children->[$_]);

    if ($para->isa('Pod::Elemental::Element::Pod5::Nonpod')) {
      if ($para->content !~ /\S/) {
        splice @{ $node->children }, $i, 1
      } else {
        confess "can't cope with a Nonpod element with non-whitespace content";
      }
    } elsif ($para->does('Pod::Elemental::Node')) {
      $self->_strip_nonpod($para);
    }
  });
}

sub prepare_input {
  my ($self, $input) = @_;
  my $pod_document = $input->{pod_document};

  Pod::Elemental::Transformer::Pod5->new->transform_node($pod_document);

  $self->_strip_nonpod($pod_document);

  return;
}

no Moose;
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Pod::Weaver::Plugin::EnsurePod5 - ensure that the Pod5 translator has been run on this document

=head1 VERSION

version 4.006

=head1 OVERVIEW

This plugin is very, very simple:  it runs the Pod5 transformer on the input
document and removes any leftover whitespace-only Nonpod elements.  If
non-whitespace-only Nonpod elements are found, an exception is raised.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut