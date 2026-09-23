# HostDocs v1.0

Node and TypeScript HTTP service with a health endpoint and automated checks.

## Commands

```bash
npm install
npm run check
npm run build
npm run dev
```

## Health check

```bash
curl http://localhost:3000/health
```

The `check` script runs typechecking, tests, and a production build in sequence.
