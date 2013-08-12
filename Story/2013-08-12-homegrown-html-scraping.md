Homegrown HTML Scraping
=======================

When it comes to scraping HTML on an iPhone, the observant developer grasps towards libxml2. It comes with iOS, so all you have to do is add some header search paths to your build settings in Xcode. Even better are the myriad libraries that wrap libxml2 in a shiny Objective-C API. Add a few files to your project and everything just works.

Until it doesn't. An XML parser is the obvious choice for parsing HTML, but it's the wrong choice. Where an HTML parser will bend over backwards trying to make sense out of whatever twisted markup you send it, an XML parser will spit out "parse error, not my problem". This is a problem when we don't control the HTML we're parsing. So this is a problem for Awful.

libxml2 actually tries to take HTML and squeeze it through its XML guts, but it falls short. Here's what Awful 1 has to work around [on the][fixing libxml parsing 1] [way in][fixing libxml parsing 2]:

- Some named entities don't need semicolons in HTML (for example, `&nbsp` is fine without a trailing semicolon), but in XML just the ampersand turns into an entity (`&amp;nbsp`).
- For whatever reason, the SA Forums sometimes include funky nonstandard HTML tags that look like `<size:2></size:2>`. libxml2 just gives up parsing immediately after encountering such a tag.

And [on the way out][fixing libxml serialization]:

- Carriage returns are written out as `&#13;`, which (when rendered as HTML) turns into uncollapsible whitespace at the start of a line.
- Childless elements such as `<b></b>` are written out as `<b/>`. Makes sense in XML, but in HTML your document just turned bold (as `<b>` is not a self-closing tag).

Surprisingly, I could not find a single HTML parser for iOS that didn't pass the buck off to libxml2. (Sure, iOS comes with WebKit, which has an excellent HTML parser sitting inside of it. But that's considered private API and apps cannot use it. (OK, that's not strictly true: apps can use it by passing the HTML to a web view and then querying the parsed HTML using JavaScript. No thanks.)) [So I made one.][HTMLReader] I sat down with [the spec][HTML spec] and [some tests][html5lib-tests] and got something that kinda works. I'll be polishing it up a bunch as I use it in Awful, but someone's gotta start using it sometime!

tl;dr Today I added HTMLReader to Awful 2.


[fixing libxml parsing 1]: https://github.com/AwfulDevs/Awful/blob/aa57f27e3747301e2ddfc87d6e35061a48c1a821/Source/Networking/AwfulJSONOrScrapeOperation.m#L107-L126
[fixing libxml parsing 2]: https://github.com/AwfulDevs/Awful/blob/a4337b71c2f4e0b4e1f1950e93bd351d0a2827dc/Source/Parsing/AwfulParsing.m#L834-L844
[fixing libxml serialization]: https://github.com/AwfulDevs/Awful/blob/c3712d55c9d539dda145d62b25279edc980b7c8f/Source/Parsing/AwfulParsing.m#L151-L168
[HTMLReader]: https://github.com/nolanw/HTMLReader
[HTML spec]: http://whatwg.org/html
[html5lib-tests]: https://github.com/html5lib/html5lib-tests/
