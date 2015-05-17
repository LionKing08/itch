
R.component "LibraryPage", {
  getInitialState: ->
    { current_panel: "owned" }

  componentDidMount: ->
    @detach = I.dispatch @, {
      set_panel: (name) =>
        @setState current_panel: name
    }

  componentDidUnmount: ->
    @detach?()

  render: ->
    div className: "library_page",
      (R.LibrarySidebar @state),
      (R.LibraryContent @state)
}

R.component "LibrarySidebar", {
  set_panel: (name) ->
    =>
      @trigger "set_panel", name

  render: ->
    (div className: "sidebar",
      (R.UserPanel {}),
      (div className: "panel_links",
        (R.LibraryPanelLink {
          name: "owned"
          label: "Owned"
          current_panel: @props.current_panel
        }),
        (R.LibraryPanelLink {
          name: "dashboard"
          label: "Dashboard"
          current_panel: @props.current_panel
        })))

}

R.component "LibraryPanelLink", {
  set_panel: (name) ->
    =>
      @trigger "set_panel", name

  render: ->
    classes = "panel_link"
    if @props.name == @props.current_panel
      classes += " current"

    div {
      className: classes
      onClick: @set_panel @props.name
    }, @props.label
}


R.component "LibraryContent", {
  getInitialState: ->
    { games: null }

  componentDidMount: ->
    I.current_user().my_games().then (res) =>
      @setState games: res.games

  render: ->
    div className: "main_content",
      if @state.games
        (R.GameList games: @state.games)
}

R.component "UserPanel", {
  getInitialState: ->
    { user: null }

  componentDidMount: ->
    I.current_user().me().then (res) =>
      @setState user: res.user
  
  render: ->
    unless @state.user
      return div className: "user_panel loading", "Loading"

    div className: "user_panel",
      "Logged in as #{@state.user.username}",
}

R.component "GameList", {
  render: ->
    div className: "game_list",
      (for game in @props.games
        R.GameCell game: game)...
}

R.component "GameCell", {
  render: ->
    game = @props.game

    thumb_classes = "game_thumb"

    if game.cover_url
      thumb_classes += " has_cover"

    div className: "game_cell",
      (div className: "bordered",
        (div {
          className: thumb_classes
          style: {
            backgroundImage: if cover = @props.game.cover_url
              "url('#{cover}')"
            }
        })),
      (div className: "game_title", game.title),
      (div className: "game_author", "Api missing author"),

}
