This plugin provides Movable Type users with an assortment of miscellaneous
tags that do not ship with Movable Type by default. These tags are divided
into several groups:

* [Modifiers](#modifiers)
  * days_old
  * nice_size
  * n_words
  * encode_json

* [Function Tags](#functions)
  * AssetModifiedDate
  * AssetModifiedBy
  * AssetFileSize
  * EntryWeekOfYear
  * SearchOffset
  * SearchLimit
  * SearchFrom
  * SearchTo

* [Conditional Tags](#condition)
  * FolderHasPages?
  * FolderHasIndex?
  * IsTopLevelFolder?
  * IfPluginInstalled?
  * CategoryHasChildren?
  * CategoryIsAncestor?
  * CategoryIsSibling?
  * CategoryIsDescendent?
  * IsPage?
  * EntryHasAssets?

* [Block/Container Tags](#block)
  * AssetEntries
  * EntryPrimaryCategory
  * AssetFilter

<a name="modifiers"></a>

# Modifiers

## `days_old`

A template tag modifier designed for use with date strings. User is intended
to use a date string formatted as a timestamp e.g. %Y%m%d%H%M%S. The tag will
then output the number of days since the date in question.

**Example**

    <ul>
    <mt:assets lastn="5">
    <li><$mt:AssetLabel$> (<$mt:AssetModifiedDate format="%Y%m%d%H%M%S" days_old="1"$> days old)</li>
    </mt:assets>
    </ul>

## `nice_size`

Transforms an integer into a nicely formatted file size, automatically
selecting kB, MB, GB, etc accordingly. You can pass in, as a value to the
modifier, the precision you would like to use (expressed as the number of
decimal places) for outputted number/file size.

**Example**

    <$mt:AssetFileSize nice_size="2"$>

## `n_words`

A template tag modifier that transforms a string by eliminating all but the
first N words from the text. The value passed to the modifier is the number of
words to truncate to. If the value passed to the modifier is an ellipsis
("...") then a ellipsis will be added to the end of the truncated string if
the truncated string does not end in a period (".").

**Example**

    <mt:section n_words="10"> Lorem ipsum dolor sit amet, consectetur
    adipiscing elit. Quisque lorem mauris </mt:section>

Returns: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque
lorem

    <mt:section n_words="10"> Lorem ipsum dolor sit amet, consectetur
    adipiscing elit. Quisque lorem mauris </mt:section>

Returns: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque
lorem...

    <mt:section n_words="10"> Lorem ipsum dolor sit amet, consectetur
    adipiscing elit. Quisque lorem mauris </mt:section>

Returns: Lorem ipsum dolor sit amet, consectetur adipiscing elit.

## `encode_json`

Escape a string to be used in a JSON object.


<a name="functions"></a>

# Function Tags

## `<$mt:AssetModifiedDate$>`

Outputs the modification date of the current asset in context. See the L<Date>
tag for supported attributes.

## `<$mt:AssetModifiedBy$>`

Outputs the author responsible for modifying the current entry in context.

## `<$mt:AssetFileSize$>`

Returns the file size, in bytes, of the asset in context.

## `<$mt:EntryWeekOfYear$>`

Returns the numerical week of year for the current entry in context.

**Example:**

    <mt:Entries>
      <mt:EntryTitle> - <mt:EntryWeekOfYear>
    </mt:Entries>

## `<mt:SearchOffset>`

Returns the raw offset of the current search results.

## `<mt:SearchLimit>`

Returns the raw limit of the current search results.
## `<mt:SearchFrom>`

Returns the effective starting position of the current result set. This is
designed to be used in a string similar to: "Showing 1 to 10 of 30," where 1
is the SearchFrom, 10 is the SearchTo and 30 is the SearchResultCount.

## `<mt:SearchTo>`

Returns the effective ending position of the current result set. This is
designed to be used in a string similar to: "Showing 1 to 10 of 30," where 1
is the SearchFrom, 10 is the SearchTo and 30 is the SearchResultCount.


<a name="condition"></a>

# Conditional Tags

## `<mt:FolderHasPages>`

A container tag that evaluates to true if the current folder in context
contains any published pages.

**Example**

    <mt:Folders>
      <mt:FolderHasPages>
        <$mt:FolderLabel$> has pages.
      <mt:Else>
        <$mt:FolderLabel$> has NO pages. 
     </mt:FolderHasPages>
    </mt:Folders>

## `<mt:FolderHasIndex></mt:FolderHasIndex>`

A container tag that evaluates to true if the current folder in context
contains a page that has a baename equal to 'index.'

**Example**

    <mt:Folders>
      <mt:FolderHasIndex>
        <$mt:FolderLabel$> has an index page.
      <mt:Else>
        <$mt:FolderLabel$> has NO index page. 
     </mt:FolderHasPages>
    </mt:Folders>

## `<mt:IsTopLevelFolder>`

Evaluates contained template tags if the current folder in context is the 
top most, root level folder on the system.

This tag is important to differentiate between the tag "HasParentFolder"
which returns false if the current folder in context is at the root level
OR the first level.

**Example:**

    <mt:Pages>
        <mt:PageFolder>
            <mt:IfTopLevelFolder>
              <$mt:PageTitle$> is in the root folder.
            </mt:IfTopLevelFolder>
        </mt:PageFolder>
    </mt:Pages>

## `<mt:IfPluginInstalled>`

Checks to see if a given plugin is installed allowing one to turn on and off
elements of a theme accordingly.

**Attributes:**

* `plugin` - The plugin ID you want to check to see is installed.

**Example:**

    <mt:IfPluginInstalled plugin="AssetGallery">
      <mt:if tag="EntryGalleryAssetCount" gt="0">
      <link rel="stylesheet" href="<mt:StaticWebPath>plugins/AssetGallery/blog/slideshow.css" type="text/css" />
      <link rel="stylesheet" href="<mt:StaticWebPath>plugins/AssetGallery/blog/jquery.jcarousel.css" type="text/css" />
      </mt:if>
    </mt:IfPluginInstalled>

## `<mt:CategoryHasChildren>`

This template tag is a conditional block tag that looks to see if the current
category in context has any child categories.

## `<mt:CategoryIsAncestor>`

This template tag is a conditional block tag that looks to see if the current
category is an ancestor to the specified category.

**Attributes:**

* `category` - The name or path of the category which you want to check
  against.

## `<mt:CategoryIsSibling>`

This template tag is a conditional block tag that looks to see if the current
category is a sibling to the specified category, or in other words if the two
categories share the same parent.

**Attributes:**

* `category` - The name or path of the category which you want to check
  against.

## `<mt:CategoryIsDescendent>`

This template tag is a conditional block tag that looks to see if the current
category is a descendent to the specified category.

**Attributes:**

* `category` - The name or path of the category which you want to check
  against.

## `<mt:IsPage>`

From time to time the mt:Entries tag is used to load both entries and pages.
This is possible because in Movable Type the system barely differentiates
between the two. So in the event that you load a page via the mt:Entries tag
(say for example in search results), then the mt:IsPage tag can be used to
disambiguates between an entry and a page.

**Example:**

    <mt:Entries>
        <mt:IsPage>
            <p><$mt:EntryTitle$> is a page.</p>
        <mt:Else>
            <p><$mt:EntryTitle$> is an entry.</p>
        </mt:IsPage>
    </mt:Entries>

## `<mt:EntryHasAssets>`

This tag returns true if the current entry in context has assets associated
with it, and false otherwise.

**Example:**

    <mt:Entries>
        <mt:EntryHasAssets>
            <p><$mt:EntryTitle$> has assets associated with it.</p>
        <mt:Else>
            <p><$mt:EntryTitle$> has no assets.</p>
        </mt:EntryHasAssets>
    </mt:Entries>


# Block/Container Tags

## `<mt:AssetEntries></mt:AssetEntries>`

Iterates over the list of entries associated with the current asset in
context.

**Example**

The following will output the title of each entry with an asset associated to
it.

    <mt:Assets>
        <mt:AssetEntries>
            <$mt:EntryTitle$>
        </mt:AssetEntries>
    </mt:Assets>

## `<mt:EntryPrimaryCategory></mt:EntryPrimaryCategory>`

There is a template tag in Movable Type that does not behave quite like you'd
expect. The template tag "mt:EntryCategory" is not a container tag that allows
you to access all aspects of the current entry's primary category. For legacy
reasons, this tag instead simply returns to the current entry's primary
category label.

This template tag provides what might otherwise expect from the
mt:EntryCategory tag. This tag is a block tag that can be used to output the
current entries primary category label, as well as basename, as well as
anything!

**Example:**

    <mt:Entries>
      <mt:EntryPrimaryCategory>
        <p><$mt:EntryTitle$> is in <$mt:CategoryLabel$> which can be found in
        <$mt:CategoryArchiveLink$></p>
      </mt:EntryPrimaryCategory>
    </mt:Entries>

## `<mt:AssetFilter></mt:AssetFilter>`

This tag makes it easy to find the desired asset to publish. By specifying some criteria for a searcch, the correct asset or asset can be returned in this block tag.

**Attributes:**

* `parent` - specify the ID of a parent asset to return all child assets.
* `class` - the class of the asset. By default all assets are returned, but this can be filtered with any asset type, such as "image" or "video."
* `label_filter` - specify a piece of text to search for in the asset's Label field. Specifying "thumbnail" will find "My awesome thumbnail," for example.
* `blog_id` - by default the current blog context is used; specify this argument to access a different blog.

**Example:**

    <mt:AssetFilter parent="123" label_filter="thumbnail">
        <h1><mt:AssetLabel></h1>
        <p><mt:AssetURL></p>
    </mt:AssetFilter>


# Requesting Template Tags of Your Own

Need a template tag for Movable Type? Ask us to write one for you. If it is
quick and easy we will happily do so:

   http://help.endevver.com/

# About Endevver

We design and develop web sites, products and services with a focus on
simplicity, sound design, ease of use and community. We specialize in Movable
Type and offer numerous services and packages to help customers make the most
of this powerful publishing platform.

http://www.endevver.com/

# Copyright

Copyright 2009-2011, Endevver, LLC. All rights reserved.

# License

This plugin is licensed under the same terms as Perl itself.