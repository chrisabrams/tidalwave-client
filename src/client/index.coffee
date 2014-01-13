_               = require 'underscore'
EventEmitter    = require('events').EventEmitter
WebSocketClient = require('websocket').client

module.exports = class TidalWaveClient

  constructor: (options) ->

    @port = options.port or 8080

    @wsClient = new WebSocketClient

    @emitter = new EventEmitter

    @on = (str, cb) =>

      @internalEvents = []

      # If an internal event is called
      if _.contains(@internalEvents, str)

        @emitter.on str, cb

      # It's a websocket event
      else

        @wsClient.on str, cb

    @using = new Array

    return @

  connect: ->

    @wsClient.connect "ws://localhost:#{@port}/", 'echo-protocol'

  disconnect: (cb) ->

    @removeAllUsed()

    if typeof cb is 'function'

      cb()

  emit: (route, pkg) ->

    @connection.sendUTF JSON.stringify({route: route, pkg: pkg})

  removeAllUsed: ->

    _.each @using, (obj, index) =>

      if typeof obj.destroy is 'function'

        obj.destroy =>

          delete @using[index]

    @using = []

  use: (obj) ->

    obj.emitter = @emitter

    #if typeof obj.onUse is 'function'
    #  obj.onUse @

    @using.push obj
