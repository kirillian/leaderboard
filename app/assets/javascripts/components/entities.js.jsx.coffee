$ ->
  window.EntitiesContainer = React.createClass
    componentWillMount: ->
      this.fetchEntities()
      setInterval(this.fetchEntities, 1000)

    fetchEntities: ->
      $.getJSON(
        this.props.entitiesPath,
        (data) =>
          this.setState({ entities: data })
      )

    getInitialState: ->
      entities: []

    render: ->
      `<Entities entities={this.state.entities}/>`

  window.Entities = React.createClass
    render: ->
      entityHtml = (entity) ->
        `<Entity entity={entity}/>`

      entitiesHtml = (entities) ->
        `<div className="entity-title-row centered">
          <ul className="panels large-block-grid-3">
            { entities.map(entityHtml) }
          </ul>
        </div>`

      entitiesHtml(this.props.entities)

  window.Entity = React.createClass
    render: ->
      entityHtml = (entity) ->
        `<div className="entity-row centered"><ul className="panels large-block-grid-3">{entityLis(entity)}</ul></div>`

      entityLis = (entity) ->
        [
          `<li className="entity-name">
            {entity.name}
          </li>`,
          `<li className="entity-score">
            {entity.score}
          </li>`,
          `<li className="entity-rank">
            {entity.rank}
          </li>`
        ]

      entityHtml(this.props.entity)

