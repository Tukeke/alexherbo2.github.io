$ ->
    # document
    article = $('article')

    # anchor headings
    article.find('h1,h2,h3,h4').each ->
        $(this).html "<a class=anchored href=##{this.id}>#{this.innerHTML}</a>"

    # requires jQuery time ago
    $('time.timeago').timeago()

    # classify hash tags
    for link in document.links
        if link.innerHTML.match '#'
            $(link).addClass 'tag'

    # Place scrolly node ───────────────────────────────────────────────────────

    place_scrolly_node = (node, selectors, node_, stop_y = 0, min_opacity = 1.0) ->
        X = [stop_y, min_opacity]

        soff = 75
        y = $(window).scrollTop()

        [node_reference, target_content, opacity, node_y] = [null, null, null, null]

        nodes = node.find selectors
        return X if not nodes.length
        nodes.each ->
            pre_node_y = $(this).position()['top'] - soff
            return X if y < pre_node_y
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
                    opacity = min_opacity if opacity > min_opacity and next_node_distance <= soff * 2

        X = [node_y, opacity]

        return X if node_y < stop_y
        node_.css(opacity:opacity).html target_content
        return X if not node_reference
        node_.one 'click', ->
            node_reference.scrollIntoView()
        X

    if $('#leaf-content').length
        $('body').append '
        <div id=scrolling-nodes>
          <a id=scrolling-h1 href=#>
          <a id=scrolling-h2 href=#>
          <a id=scrolling-h3 href=#>
          <a id=scrolling-h4 href=#>
        </div>'
        node = $('#leaf-content')
        snip = ->
            for id, selectors of {'scrolling-h1':'h1','scrolling-h2':'h2','scrolling-h3':'h3','scrolling-h4':'h4'}
                node_ = $("##{id}"); node_.html ''
                [stop_y, opacity] = place_scrolly_node(node, selectors, node_, stop_y or 0, opacity or 1.0)
        $(window).scroll(snip)
        $(window).resize(snip)
