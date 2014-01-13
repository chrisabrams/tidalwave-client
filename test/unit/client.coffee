Client = require '../../src/client/index'

describe 'Client - Unit', ->

  it 'should initialize', (done) ->

    client = new Client
      port: 8000

    expect(client).to.be.an 'object'
    expect(client.on).to.be.a 'function'

    done()
