Blog,
Drafts,
Personal wiki / recipes.

Design
------

Theme is inspired by [CLIs][] and [Man][],
color palette is [Solarized][] and font [Menlo][] (not free).

Source structure
----------------

```
.
├── assets
│   ├── coffee
│   │   └── script.coffee
│   ├── fonts
│   │   └── menlo.ttf
│   ├── haml
│   │   └── helpers.rb
│   ├── images
│   │   └── favicon.ico
│   └── sass
│       ├── solarized.sass
│       └── style.sass
├── build
├── git
│   └── hooks
├── layouts
│   ├── base.haml
│   ├── page.haml
│   └── post.haml
└── src
```

Building
--------

alexherbo2’s user site dependencies are:

 * [Pandoc](http://johnmacfarlane.net/pandoc)
 * [Haml](http://haml.info)
 * [Sass](http://sass-lang.com)
 * [CoffeeScript](http://coffeescript.org)
 * [Kakoune](https://github.com/mawww/kakoune)

To build, just type `build` in the root directory.  The site will be deployed in
[master][] branch.  It is best viewed at [alexherbo2.github.io][].

Plug-in
-------

 * [jQuery](http://jquery.com)
   - [timeago](http://timeago.yarp.com)
   - [scrollIntoView](http://arwid.github.io/jQuery.scrollIntoView)
 * [Disqus](http://disqus.com)

Caching
-------

The site caches meta data in [localStorage][].
Hence it can display visited links differently.
To clear, open the [page inspector][] (`ctrl+shift+i` in major browsers),
then enter `localStorage.clear()` JS code in [❯ Console][].


[alexherbo2.github.io]: http://alexherbo2.github.io
[source]: https://github.com/alexherbo2/alexherbo2.github.io/tree/source
[master]: https://github.com/alexherbo2/alexherbo2.github.io/tree/master
[CLIs]: https://en.wikipedia.org/wiki/Command-line_interface
[Man]: https://en.wikipedia.org/wiki/Man_page
[Solarized]: http://ethanschoonover.com/solarized
[Menlo]: http://leancrew.com/all-this/2009/10/the-compleat-menlovera-sans-comparison
[localStorage]: http://en.wikipedia.org/wiki/Web_storage#localStorage
[page inspector]: https://developer.mozilla.org/docs/Tools/Page_Inspector
[❯ Console]: https://developer.mozilla.org/docs/Tools/Web_Console
