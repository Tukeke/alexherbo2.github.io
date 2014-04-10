Blog,
Drafts,
Personal wiki / recipes.
Static site, with [no Jekyll][Jekyll].

Design
------

Theme is inspired by [text-based web browsers][text-based web browser],
color palette is [Solarized][] and font [Menlo][] (not free).

[![](http://i.imgur.com/yPfzzQrl.png 'Lynx text web browser')](http://i.imgur.com/yPfzzQr.png)

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
│   ├── page.haml
│   └── post.haml
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
 * [Disqus](http://disqus.com)
 * [Spotify Play Button](https://developer.spotify.com/technologies/widgets/spotify-play-button)
 * [YouTube Player](https://developers.google.com/youtube)


[alexherbo2.github.io]: http://alexherbo2.github.io
[source]: https://github.com/alexherbo2/alexherbo2.github.io/tree/source
[master]: https://github.com/alexherbo2/alexherbo2.github.io/tree/master
[Jekyll]: http://jekyllrb.com
[text-based web browser]: http://en.wikipedia.org/wiki/Text-based_web_browser
[Solarized]: http://ethanschoonover.com/solarized
[Menlo]: http://leancrew.com/all-this/2009/10/the-compleat-menlovera-sans-comparison
