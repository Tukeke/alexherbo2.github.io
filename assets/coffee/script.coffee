$ ->
    # document
    article = document.querySelector 'article'

    # requires jQuery time ago
    jQuery(document).ready ->
        jQuery('time.timeago').timeago()

    # classify hash tags
    for link in document.links
        if link.innerHTML.match '#'
            link.className += 'tag'

    # link:visited:after emulation

    # We are not allowed to link:visited:after → content
    # Visited class does the trick anyway.
    # https://developer.mozilla.org/en-US/docs/Web/CSS/Privacy_and_the_:visited_selector
    visited_links = localStorage.getItem 'visited_links'

    article_links = article.getElementsByTagName 'a'

    if not visited_links?
        localStorage.setItem 'visited_links', []
    else
        for link in article_links
            link.className += 'visited' if visited_links.indexOf(link.href) >-1

    for link in article_links
        link.addEventListener 'click', (link) ->
            link.target.className += 'visited'
            localStorage.setItem 'visited_links', localStorage.getItem('visited_links') + [link.target.href]

    # Place scrolly node ───────────────────────────────────────────────────────

    place_scrolly_node = (node, selectors, id) ->
        soff = 75
        y = $(window).scrollTop()

        [node_reference, target_content, opacity, node_y] = [null, null, null, null]

        nodes = node.find selectors
        return if not nodes.length
        nodes.each ->
            pre_node_y = $(this).position()['top'] - soff
            return false if y < pre_node_y
            node_y = pre_node_y
            node_reference = $(this)
            target_content = $(this).html()
            opacity_y = y - (node_y + soff)
            opacity = opacity_y / soff
            opacity = 1.0 if opacity > 1.0
            if opacity > 0.99
                next_nodes = $(this).nextAll(selectors)
                if next_nodes.length
                    next_node_y = next_nodes.first().position()['top']
                    next_node_distance = next_node_y - y
                    opacity = 1.0 / (soff - next_node_distance / 2) if next_node_distance <= soff * 2

        selected_element = $("##{id}")
        return if not selected_element
        selected_element.css(opacity:opacity).html target_content
        return if not node_reference
        selected_element.one 'click', ->
            node_reference.scrollIntoView()

    if $('#leaf-content').length
        $('body').append '
        <div id=scrolling-nodes>
          <a id=scrolling-h1 href=#>
          <a id=scrolling-h2 href=#>
          <a id=scrolling-h3 href=#>
          <a id=scrolling-h4 href=#>
        </div>'
        node = $('#leaf-content')
        for id, selectors of {'scrolling-h1':'h1','scrolling-h2':'h2','scrolling-h3':'h3','scrolling-h4':'h4'}
            $(window).scroll(place_scrolly_node.bind(null, node, selectors, id))
            $(window).resize(place_scrolly_node.bind(null, node, selectors, id))
