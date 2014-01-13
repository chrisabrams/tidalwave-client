Client = require '../../src/client/index'
Router = require 'tidalwave-router'
Server = require 'tidalwave'

describe 'Client - Functional', ->

  it 'should fire route callback on match', (done) ->

    server = new Server
      port: 8000

    server.on 'request', (request) ->
      connection = request.accept 'echo-protocol', request.origin

      router2 = new Router connection, request
      server.use router2

      router2.dispatch 'yo', {}

    client = new Client
      port: 8000

    client.on 'connect', (connection) ->

      router1 = new Router connection

      client.use router1

      router1.on 'yo', (pkg, conn, req) ->

        expect(pkg).to.be.an 'object'
        expect(conn).to.be.an 'object'
        expect(req).to.equal undefined

        client.disconnect ->

          server.shutdown ->

            done()

    client.connect()

  it 'should receive a data package', (done) ->

    server = new Server
      port: 8000

    server.on 'request', (request) ->
      connection = request.accept 'echo-protocol', request.origin

      router2 = new Router connection, request
      server.use router2

      router2.dispatch 'yo', {name: 'Chris'}

    client = new Client
      port: 8000

    client.on 'connect', (connection) ->

      router1 = new Router connection

      client.use router1

      router1.on 'yo', (pkg, conn, req) ->

        expect(pkg).to.be.an 'object'
        expect(pkg.name).to.equal 'Chris'

        client.disconnect ->

          server.shutdown ->

            done()

    client.connect()

  it 'should dispatch', (done) ->

    server = new Server
      port: 8000

    server.on 'request', (request) ->
      connection = request.accept 'echo-protocol', request.origin

      router = new Router connection, request

      router.on 'yo', (pkg, conn, req) ->

        expect(pkg).to.be.an 'object'
        expect(conn).to.be.an 'object'
        expect(req).to.be.an 'object'

        server.shutdown ->
          done()

    client = new Client
      port: 8000

    client.on 'connect', (connection) ->

      router = new Router connection

      client.use router

      router.dispatch 'yo', {}

    client.connect()
