This plugin provides Movable Type users with an assortment of miscellaneous tags that do not ship with Movable Type by default. These tags are:

# Modifiers

## `days_old`

A template tag modifier designed for use with date strings. User is intended to use a date string formatted as a timestamp e.g. %Y%m%d%H%M%S. The tag will then output the number of days since the date in question.

**Example**

    <ul>
    <mt:assets lastn="5">
    <li><$mt:AssetLabel$> (<$mt:AssetModifiedDate format="%Y%m%d%H%M%S" days_old="1"$> days old)</li>
    </mt:assets>
    </ul>

# Template Tags

**This plugin offers far more template tags than are listed here. Documentation can be found for each tag in the plugins/ExtraTags/lib/ExtraTags/Plugin.pm file. Obviously this is not ideal. You can also get a definitive list of tags provided from plugins/ExtraTags/config.yaml.**

## `<mt:IsTopLevelFolder>`
## `<mt:IfPluginInstalled>`

Checks to see if a given plugin is installed allowing one to turn on and off
elements of a theme accordingly.

**Attributes:**

* plugin: The plugin ID you want to check to see is installed.

**Example:**

    <mt:IfPluginInstalled plugin="AssetGallery">
      <mt:if tag="EntryGalleryAssetCount" gt="0">
      <link rel="stylesheet" href="<mt:StaticWebPath>plugins/AssetGallery/blog/slideshow.css" type="text/css" />
      <link rel="stylesheet" href="<mt:StaticWebPath>plugins/AssetGallery/blog/jquery.jcarousel.css" type="text/css" />
      </mt:if>
    </mt:IfPluginInstalled>

## `<mt:CategoryHasChildren>`

This template tag is a conditional block tag that looks to see if the
current category in context has any child categories.

## `<mt:CategoryIsAncestor>`
## `<mt:CategoryIsSibling>`
## `<mt:CategoryIsDescendent>`
## `<mt:EntryPrimaryCategory>`

Sets the current context to the current entry's primary category

## `<mt:AssetFileSize>`
## `<mt:EntryWeekOfYear>`
## `<mt:SearchOffset>`

Returns the raw offset of the current search results.

## `<mt:SearchLimit>`

Returns the raw limit of the current search results.
## `<mt:SearchFrom>`

Returns the effective starting position of the current result set. This is
designed to be used in a string similar to: "Showing 1 to 10 of 30," where
1 is the SearchFrom, 10 is the SearchTo and 30 is the SearchResultCount.

## `<mt:SearchTo>`

Returns the effective ending position of the current result set. This is
designed to be used in a string similar to: "Showing 1 to 10 of 30," where
1 is the SearchFrom, 10 is the SearchTo and 30 is the SearchResultCount.

## `<mt:FolderHasPages>`

A container tag that evaluates to true if the current folder in context contains any published pages.

**Example**

    <mt:Folders>
      <mt:FolderHasPages>
        <$mt:FolderLabel$> has pages.
      <mt:Else>
        <$mt:FolderLabel$> has NO pages. 
     </mt:FolderHasPages>
    </mt:Folders>

## `<mt:FolderHasIndex></mt:FolderHasIndex>`

A container tag that evaluates to true if the current folder in context contains a page that has a baename equal to 'index.'

**Example**

    <mt:Folders>
      <mt:FolderHasIndex>
        <$mt:FolderLabel$> has an index page.
      <mt:Else>
        <$mt:FolderLabel$> has NO index page. 
     </mt:FolderHasPages>
    </mt:Folders>

## `<$mt:AssetModifiedDate$>`

Outputs the modification date of the current asset in context. See the L<Date> tag for supported attributes.

## `<mt:AssetEntries></mt:AssetEntries>`

Iterates over the list of entries associated with the current asset in context.

**Example**

The following will output the title of each entry with an asset associated to it.

    <mt:Assets>
        <mt:AssetEntries>
            <$mt:EntryTitle$>
        </mt:AssetEntries>
    </mt:Assets>


# Requesting Template Tags of Your Own

Need a template tag for Movable Type? Ask us to write one for you. If it is quick and easy we will happily do so:

   http://help.endevver.com/

# About Endevver

We design and develop web sites, products and services with a focus on 
simplicity, sound design, ease of use and community. We specialize in 
Movable Type and offer numerous services and packages to help customers 
make the most of this powerful publishing platform.

http://www.endevver.com/

# Copyright

Copyright 2009-2011, Endevver, LLC. All rights reserved.

# License

This plugin is licensed under the same terms as Perl itself.