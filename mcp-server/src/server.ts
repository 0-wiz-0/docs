import express from 'express'
import { Server } from '@modelcontextprotocol/sdk/server/index.js'
import { StreamableHTTPServerTransport } from '@modelcontextprotocol/sdk/server/streamableHttp.js'
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  type CallToolResult,
  type Tool,
} from '@modelcontextprotocol/sdk/types.js'

const tools: Tool[] = [
  {
    name: 'read-repo-status',
    description: 'Returns a concise summary of the repository working state.',
    inputSchema: {
      type: 'object',
      properties: {
        path: {
          type: 'string',
          description: 'Optional path to summarize relative to the repo root.',
        },
      },
      additionalProperties: false,
    },
  },
  {
    name: 'echo',
    description: 'Echo a message back to the client.',
    inputSchema: {
      type: 'object',
      properties: {
        message: {
          type: 'string',
          description: 'Message to echo back.',
        },
      },
      required: ['message'],
      additionalProperties: false,
    },
  },
]

const server = new Server(
  {
    name: 'hostdocs-first-party-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  },
)

server.setRequestHandler(ListToolsRequestSchema, async () => ({ tools }))

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const name = request.params.name
  const args = request.params.arguments ?? {}

  if (name === 'echo') {
    const message = typeof args.message === 'string' ? args.message : ''
    const result: CallToolResult = {
      content: [{ type: 'text', text: `Echo: ${message}` }],
    }
    return result
  }

  if (name === 'read-repo-status') {
    const repoPath = typeof args.path === 'string' ? args.path : '.'
    const result: CallToolResult = {
      content: [
        {
          type: 'text',
          text: `Repository status for ${repoPath}: workspace is available and ready for tool use.`,
        },
      ],
    }
    return result
  }

  throw new Error(`Unknown tool: ${name}`)
})

async function main(): Promise<void> {
  const app = express()
  const port = Number(process.env.PORT ?? 3000)

  app.use(express.json())

  app.post('/mcp', async (req, res) => {
    const transport = new StreamableHTTPServerTransport({
      sessionIdGenerator: undefined,
      enableJsonResponse: true,
    })

    res.on('close', async () => {
      await transport.close()
    })

    await server.connect(transport)
    await transport.handleRequest(req, res, req.body)
  })

  app.get('/health', (_req, res) => {
    res.json({ ok: true, service: 'hostdocs-mcp-server' })
  })

  app.listen(port, '0.0.0.0', () => {
    console.error(`HostDocs MCP HTTP server listening on http://0.0.0.0:${port}`)
  })
}

void main()
