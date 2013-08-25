Improved HTML Scraping
======================

I spent the last ten days' Awful time fixing some bugs in Awful 1 and improving the new HTML scraper. Thanks to [ultramiraculous][] the [HTMLReader project][HTMLReader] has working CSS selectors!

Now that it's easy to find the bits of HTML we want, the next step is to correctly handle whitespace. The HTML spec describes inter-element whitespace and defers to the CSS spec for collapsing whitespace and breaking lines. Ideally that would be implemented directly in the HTML parsing library, but that requires actual adherence to the spec. Whereas Awful 2 can probably get away with less than a full spec implementation.

Most happily I'm not alone in development. [leper khan][] is jumping into an emoticon chooser keyboard selector thing! Always nice to get help on a big feature. It gets a little lonely sometimes...

[HTMLReader]: https://github.com/nolanw/HTMLReader
[leper khan]: http://forums.somethingawful.com/member.php?action=getinfo&userid=171201
[ultramiraculous]: http://forums.somethingawful.com/member.php?action=getinfo&userid=44504
