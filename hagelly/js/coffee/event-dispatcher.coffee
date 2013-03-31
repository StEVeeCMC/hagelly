class @EventDispatcher
  constructor: ->
    @eventable = $ @

  on: (events, handler) -> @eventable.on events, handler

  bind: (eventType, handler) -> @eventable.bind eventType, handler

  trigger: (eventType, extraParameters) -> @eventable.trigger eventType, extraParameters

