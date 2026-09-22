import assert from 'node:assert/strict'
import { once } from 'node:events'
import test from 'node:test'

import app from '../src/index.js'

test('health endpoint reports service status', async () => {
  const server = app.listen(0)
  await once(server, 'listening')

  try {
    const address = server.address()
    assert.ok(address && typeof address !== 'string')

    const response = await fetch(`http://127.0.0.1:${address.port}/health`)
    assert.equal(response.status, 200)
    assert.deepEqual(await response.json(), {
      ok: true,
      service: 'hostdocs-v1',
      version: '1.0.0',
    })
  } finally {
    server.close()
  }
})
