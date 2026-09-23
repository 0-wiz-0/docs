import express from 'express'

const app = express()
const port = Number(process.env.PORT ?? 3000)

app.get('/health', (_req, res) => {
  res.json({ ok: true, service: 'hostdocs-v1', version: '1.0.0' })
})

if (process.env.NODE_ENV !== 'test') {
  app.listen(port, '0.0.0.0', () => {
    console.log(`HostDocs v1.0 listening on http://0.0.0.0:${port}`)
  })
}

export default app
