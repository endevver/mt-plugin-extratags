# Copyright (C) 2009 Byrne Reese.
package ExtraTags::Plugin;

use strict;
use MT::Util qw( ts2epoch );

###########################################################################

=head2 mt:AssetFileSize

This returns the file size of the current asset in context.

B<Attributes:>

None.

=for tags plugin, function, asset, size

=cut

sub tag_asset_size {
    my ( $ctx, $args, $cond ) = @_;
    my $asset = $ctx->stash('asset');
    # TODO - error if no asset
    return -s $asset->file_path;    
}

###########################################################################

=head2 mt:FolderHasPages

This template tag is a conditional block tag that is evaluated if the 
current folder in context has any pages within it.

B<Attributes:>

None.

=for tags plugin, block, container, conditional, folder, pages

=cut
sub tag_has_pages {
    my ($ctx, $args, $cond) = @_;
    my $c = $ctx->stash('category')
        or return _no_folder_error($ctx);
    require MT::Page;
    require MT::Placement;
    my $clause = ' = entry_entry_id';
    my %args = (
        join => MT::Placement->join_on( category_id => $c->id, { entry_id => \$clause }),
        );

    my $count = MT->model('page')->count( undef , $args);
    return $count > 0;
}

###########################################################################

=head2 mt:FolderHasIndex

This template tag is a conditional block tag that is evaluated if the 
current folder in context has a page with a basename of 'index', or in
laymans terms: an index page (e.g. index.php or index.html).

B<Attributes:>

None.

=for tags plugin, block, container, conditional, folder, pages

=cut
sub tag_has_index {
    my ($ctx, $args, $cond) = @_;
    my $c = $ctx->stash('category')
        or return _no_folder_error($ctx);
    require MT::Placement;
    my $clause = ' = entry_id';
    my %args = (
		'join' => MT::Placement->join_on( 'entry_id' , { 
		      entry_id => \$clause,
		      category_id => $c->id,
		   }),
		);
    require MT::Page;
    my @pages = MT::Page->load({ basename => 'index' }, \%args);
    return $#pages > -1;
}

sub _no_folder_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    $tag_name = 'mt' . $tag_name unless $tag_name =~ m/^MT/i;
    return $ctx->error(MT->translate(
        "You used an '[_1]' tag outside of the context of a folder; " .
        "perhaps you mistakenly placed it outside of an 'MTFolders' " .
        "container?", $tag_name
    ));
}

sub _no_category_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    $tag_name = 'mt' . $tag_name unless $tag_name =~ m/^MT/i;
    return $ctx->error(MT->translate(
        "You used an '[_1]' tag outside of the context of a category; " .
        "perhaps you mistakenly placed it outside of an 'MTCategories' " .
        "container?", $tag_name
    ));
}

###########################################################################

=head2 AssetModifiedDate

Outputs the modification date of the current entry in context.
See the L<Date> tag for supported attributes.

=for tags date

=cut

sub tag_asset_mod_date {
    my ($ctx, $args) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    $args->{ts} = $a->modified_on || $a->created_on;
    return MT::Template::Context::_hdlr_date($ctx, $args);
}

###########################################################################

=head2 AssetModifiedBy

Outputs the author responsible for modifying the current entry in context.

=for tags date

=cut

sub tag_asset_mod_by {
    my ($ctx, $args) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();

    my $author_id = $a->modified_by || $a->created_by;
    my $author = MT->model('author')->load($author_id);
    return '' unless $author;
    return $author->nickname || $author->name;
}

###########################################################################

=head2 days_old

A template tag modifier that transforms a date into an integer representing 
the number of days from now (the time the tag was processed) and the tag 
itself.
                                                                                                      
=for tags date

=cut

sub mod_days_old {
    my ($ts, $val, $ctx) = @_;
    my $epoch = ts2epoch(undef,$ts);
    my $now = time();
    my $diff = $now - $epoch;
    return int($diff / ( 60 * 60 * 24));
}

###########################################################################

=head2 AssetEntries

Iterates over the list of entries associated with the current asset in 
context.

B<Example:>

The following will output the title of each entry with an asset associated 
to it.

    <mt:Assets>
        <mt:AssetEntries>
            <$mt:EntryTitle$>
        </mt:AssetEntries>
    </mt:Assets>

=for assets entry

=cut

sub tag_asset_entries {
    my ($ctx, $args, $cond) = @_;
    my $obj = $ctx->stash('asset')
        or return $ctx->_no_asset_error();

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    my $place_class = MT->model('objectasset');
    my @places = $place_class->load({
        blog_id => $obj->blog_id || 0,
        asset_id => $obj->parent ? $obj->parent : $obj->id
    });
    my $res = '';
    my $count = 0;
    my $vars = $ctx->{__stash}{vars};
    foreach my $place (@places) {
        my $entry_class = MT->model($place->object_ds) or next;
        next unless $entry_class->isa('MT::Entry');
        my $entry = $entry_class->load($place->object_id)
            or next;
        # Only include published entries.
        next unless ( $entry->status == MT::Entry::RELEASE() );
        local $vars->{'__first__'}   = ($count == 0);
        local $vars->{'__last__'}    = ($count == $#places);
        local $vars->{'__odd__'} = ($count % 2 ) == 1;
        local $vars->{'__even__'} = ($count % 2 ) == 0;
        local $vars->{'__counter__'} = ++$count;
        local $ctx->{__stash}{'entry'} = $entry;
        defined(my $out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error($builder->errstr);
        $res .= $out;
    }

    return $res;
}

###########################################################################

=head2 IsTopLevelFolder

Evaluates contained template tags if the current folder in context is the 
top most, root level folder on the system.

This tag is important to differentiate between the tag "HasParentFolder"
which returns false if the current folder in context is at the root level
OR the first level.

B<Example:>

    <mt:Pages>
        <mt:PageFolder>
            <mt:IfTopLevelFolder>
              <$mt:PageTitle$> is in the root folder.
            </mt:IfTopLevelFolder>
        </mt:PageFolder>
    </mt:Pages>

=for assets entry

=cut

sub tag_is_top_level {
    my ($ctx, $args) = @_;
    # Get the current category
    defined (my $cat = MT::Template::Context::_get_category_context($ctx))
        or return $ctx->error($ctx->errstr);
    return $ctx->error("Could not find a category in current context.")
        if ($cat eq '');
    return $cat->parent == 0 ? 1 : 0;
}

###########################################################################

=head2 nice_size

Transforms an integer into a nicely formatted file size, automatically selecting
kB, MB, GB, etc accordingly. You can pass in, as a value to the modifier, the
precision you would like to use (expressed as the number of decimal places)
for outputted number/file size.

B<Example:>

    <$mt:AssetFileSize nice_size="2"$>

=for tags 

=cut

sub mod_nice_size {
    # Will work up to considerable file sizes!
    my $fs = $_[0] || 0; # First variable is the size in bytes
    my $dp = $_[1] || 0; # Number of decimal places required
    my @units = ('bytes','kB','MB','GB','TB','PB','EB','ZB','YB');
    my $u = 0;
    $dp = ($dp > 0) ? 10**$dp : 1;
    while($fs > 1024){
        $fs /= 1024;
        $u++;
    }
    if($units[$u]){ return (int($fs*$dp)/$dp)." ".$units[$u]; } else{ return int($_[0]); }
}

###########################################################################

=head2 IfPluginInstalled

Checks to see if a given plugin is installed allowing one to turn on and off 
elements of a theme accordingly.

B<Attributes:>

=over

=item plugin

The plugin ID you want to check to see is installed.

B<Example:>

    <mt:IfPluginInstalled plugin="AssetGallery">
      <mt:if tag="EntryGalleryAssetCount" gt="0">
      <link rel="stylesheet" href="<mt:StaticWebPath>plugins/AssetGallery/blog/slideshow.css" type="text/css" />
      <link rel="stylesheet" href="<mt:StaticWebPath>plugins/AssetGallery/blog/jquery.jcarousel.css" type="text/css" />
      </mt:if>
    </mt:IfPluginInstalled>

=for tags 

=cut

sub tag_plugin_installed {
    my($ctx, $args, $cond) = @_;
    my $p = $args->{'plugin'};
    return 1 if (MT->component($p));
    return 0;
}

###########################################################################

=head2 EntryWeekOfYear

Returns the numerical week of year for the current entry in context.

B<Example:>

    <mt:Entries>
      <mt:EntryTitle> - <mt:EntryWeekOfYear>
    </mt:Entries>

=for entry date

=cut

sub tag_week_of_year {
    my ($ctx) = @_;
    my $entry = $ctx->stash('entry');
    my $week = substr($entry->week_number(), 4, length($entry->week_number()));
    return $week || '';
}

###########################################################################

=head2 mt:HasChildCategory

This template tag is a conditional block tag that looks to see if the
current category in context has any child categories.

B<Attributes:>

None.

=for tags plugin, block, container, conditional, category

=cut
sub tag_has_children {
    my ($ctx, $args, $cond) = @_;
    defined (my $c = MT::Template::Context::_get_category_context($ctx))
        or return _no_category_error($ctx);
    my $count = MT->model('category')->count({ parent => $c->id });
    return $count > 0 ? 1 : 0;
}

sub tag_is_ancestor {
    my ($ctx, $args, $cond) = @_;
    my $class_type = $args->{class_type} || 'category';
    require MT::Template::ContextHandlers;
    defined (my $target = MT::Template::Context::_get_category_context($ctx))
        or return _no_category_error($ctx);

    my $tag_name = $ctx->stash('tag');
    my $cursor;
    if ($args->{category_id}) {
        $cursor = MT->model($class_type)->load( $args->{category_id} );
    } else {
        ($cursor) = MT::Template::Context::cat_path_to_category($args->{category}, $ctx->stash('blog_id'), $class_type);
    }
    unless ($cursor) {
        return $ctx->error(MT->translate(
                               "Could not find category '[_1]' in tag [_2]",
                               $args->{category_id} ? '#'.$args->{category_id} : $args->{category}, 
                               $tag_name));
    }
    return 0 unless $cursor->parent;
    return 0 if $cursor->id == $target->id; # Ancestors MUST precede the start
    while ( $cursor = $cursor->parent_category ) {
        if ($cursor->id == $target->id) {
            # if the parent is the same as the target
            # then return, otherwise go to the next parent
            return 1;
        }
    }
    return 0;
}


sub tag_is_descendent {
    my ($ctx, $args, $cond) = @_;
    my $class_type = $args->{class_type} || 'category';
    require MT::Template::ContextHandlers;
    defined (my $cursor = MT::Template::Context::_get_category_context($ctx))
        or return _no_category_error($ctx);

    my $tag_name = $ctx->stash('tag');
    my $target;
    if ($args->{category_id}) {
        $target = MT->model($class_type)->load( $args->{category_id} );
    } else {
        ($target) = MT::Template::Context::cat_path_to_category($args->{category}, $ctx->stash('blog_id'), $class_type);
    }
    unless ($target) {
        return $ctx->error(MT->translate(
                               "Could not find category '[_1]' in tag [_2]",
                               $args->{category_id} ? '#'.$args->{category_id} : $args->{category}, 
                               $tag_name));
    }
    return 0 unless $cursor->parent;
    return 0 if $cursor->id == $target->id; # Ancestors MUST precede the start
    while ( $cursor = $cursor->parent_category ) {
        if ($cursor->id == $target->id) {
            # if the parent is the same as the target
            # then return, otherwise go to the next parent
            return 1;
        }
    }
    return 0;
}

sub tag_is_sibling {
    my ($ctx, $args, $cond) = @_;
    my $class_type = $args->{class_type} || 'category';
    require MT::Template::ContextHandlers;
    defined (my $cursor = MT::Template::Context::_get_category_context($ctx))
        or return _no_category_error($ctx);

    my $tag_name = $ctx->stash('tag');
    my $target;
    if ($args->{category_id}) {
        $target = MT->model($class_type)->load( $args->{category_id} );
    } else {
        ($target) = MT::Template::Context::cat_path_to_category($args->{category}, $ctx->stash('blog_id'), $class_type);
    }
    unless ($target) {
        return $ctx->error(MT->translate(
                               "Could not find category '[_1]' in tag [_2]",
                               $args->{category_id} ? '#'.$args->{category_id} : $args->{category}, 
                               $tag_name));
    }

    return 1 if ($cursor->parent == $target->parent);
    return 0;
}

###########################################################################

=head2 EntryPrimaryCategory

There is a template tag in Movable Type that does not behave quite like you'd expect. 
The template tag "<mt:EntryCategory>" is not a container tag that allows you to access
all aspects of the current entry's primary category. For legacy reasons, this tag
instead simply returns to the current entry's primary category label.

B<This> template tag provides what might otherwise expect from the mt:EntryCategory 
tag. This tag is a block tag that can be used to output the current entries
primary category label, as well as basename, as well as anything!

B<Example:>

    <mt:Entries>
      <mt:EntryPrimaryCategory>
        <p><$mt:EntryTitle$> is in <$mt:CategoryLabel$> which can be found in
        <$mt:CategoryArchiveLink$></p>
      </mt:EntryPrimaryCategory>
    </mt:Entries>

=for entry date

=cut

sub tag_entry_category {
    my($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $cat = $e->category;
    return '' unless $cat;
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $res = '';
    local $ctx->{inside_mt_categories} = 1;
    local $ctx->{__stash}->{category} = $cat;
    defined(my $out = $builder->build($ctx, $tokens, $cond))
        or return $ctx->error( $builder->errstr );
    return $out;
}

1;
