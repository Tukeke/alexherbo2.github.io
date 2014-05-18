Blog,
Drafts,
Personal wiki / recipes.
Static site, with [no Jekyll][Jekyll].

Design
------

Theme is inspired by [CLIs][CLI],
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
├── content
├── git
│   └── hooks
│       └── pre-push
├── layouts
│   ├── base.haml
│   └── page.haml
├── nginx.conf
└── CNAME
```

Building
--------

alexherbo2’s user site dependencies are:

 * [fish](http://fishshell.com) which is used as a glue to other tools
 * [Pandoc](http://johnmacfarlane.net/pandoc)
 * [Haml](http://haml.info)
 * [Compass](http://compass-style.org) which uses [Sass](http://sass-lang.com)
 * [CoffeeScript](http://coffeescript.org)
 * [Kakoune](https://github.com/mawww/kakoune)

To build, just type [build](build) in the root directory.  The site will be
deployed in [master][] branch.  It is best viewed at [alexherbo2.github.io][].

Plug-in
-------

 * [GitHub](https://github.com)
 * [jQuery](http://jquery.com)
   - [timeago](http://timeago.yarp.com)
   - [scrollIntoView](http://arwid.github.io/jQuery.scrollIntoView)
 * [Gittip](https://gittip.com)
 * [Flattr](https://flattr.com)
 * [Disqus](http://disqus.com)
 * [Spotify Play Button](https://developer.spotify.com/technologies/widgets/spotify-play-button)
 * [YouTube Player](https://developers.google.com/youtube)


[alexherbo2.github.io]: http://alexherbo2.github.io
[source]: https://github.com/alexherbo2/alexherbo2.github.io/tree/source
[master]: https://github.com/alexherbo2/alexherbo2.github.io/tree/master
[Jekyll]: http://jekyllrb.com
[CLI]: http://en.wikipedia.org/wiki/Command-line_interface
[Solarized]: http://ethanschoonover.com/solarized
[Menlo]: http://leancrew.com/all-this/2009/10/the-compleat-menlovera-sans-comparison
