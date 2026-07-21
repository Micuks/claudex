# claudex

**Claude Code harness + Codex models**, routed through a local [CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI).

```
Claude Code  ──ANTHROPIC_BASE_URL──►  CLIProxyAPI(:8317)  ──Codex OAuth──►  GPT-5.6
```

Plain `claude` is untouched — env vars only apply inside the `claudex` process.

## One-line install

### curl (recommended on servers)

```bash
curl -fsSL https://raw.githubusercontent.com/Micuks/claudex/main/install.sh | bash
```

Pin a tag / skip proxy binary:

```bash
CLAUDEX_REF=v0.1.0 curl -fsSL https://raw.githubusercontent.com/Micuks/claudex/v0.1.0/install.sh | bash
CLAUDEX_SKIP_CLIPROXY=1 curl -fsSL https://raw.githubusercontent.com/Micuks/claudex/main/install.sh | bash
```

### npm / npx (from GitHub — no npm login required)

```bash
npm install -g github:Micuks/claudex
# or one-shot:
npx --yes github:Micuks/claudex doctor
```

### Prerequisites

| Tool | Why |
|------|-----|
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | harness (`npm i -g @anthropic-ai/claude-code`) |
| curl or wget, tar, python3 | installer + helpers |
| macOS or Linux | CLIProxyAPI release targets |

## Quick start

```bash
claudex setup          # download CLIProxyAPI + write ~/.cli-proxy-api/config.yaml
claudex login          # browser OAuth (or: claudex login --device)
# alternative if Codex CLI is already logged in:
claudex import-auth

claudex                # default model: gpt-5.6-sol
claudex --continue
CLAUDEX_MODEL=gpt-5.6-terra claudex
claudex doctor
```

## Model mapping

| Claude tier | Codex model (default) |
|-------------|------------------------|
| default / Opus | `gpt-5.6-sol` |
| Sonnet / subagents | `gpt-5.6-terra` |
| Haiku | `gpt-5.6-luna` |

Override with env: `CLAUDEX_MODEL`, `CLAUDEX_OPUS_MODEL`, `CLAUDEX_SONNET_MODEL`, `CLAUDEX_HAIKU_MODEL`.

## Commands

```
claudex [claude-args...]
claudex setup [--force]
claudex login [--device]
claudex import-auth [path]
claudex proxy start|stop|status|logs
claudex models
claudex doctor
claudex version
```

## Configuration

| Path | Purpose |
|------|---------|
| `~/.cli-proxy-api/config.yaml` | CLIProxyAPI config (auto-created) |
| `~/.cli-proxy-api/codex-*.json` | Codex OAuth tokens |
| `~/.local/bin/cli-proxy-api` | proxy binary |
| `~/.local/bin/claudex` | this wrapper |

Defaults:

- listen `127.0.0.1:8317`
- client token `sk-claudex-local` (`CLIPROXY_API_KEY`)
- pinned CLIProxyAPI `v7.2.93` (`CLIPROXY_VERSION=latest` to float)

## Publish notes (maintainers)

```bash
# GitHub already is the distribution channel for curl + npm github:
git tag v0.1.0 && git push origin v0.1.0
gh release create v0.1.0 --generate-notes

# Optional registry publish (requires npm login):
npm publish
```

## Security / ToS

- Credentials live only on the machine under `~/.cli-proxy-api/`.
- CLIProxyAPI uses your ChatGPT/Codex subscription OAuth; respect OpenAI usage limits and terms.
- Do not expose port `8317` to the public internet without auth hardening.

## License

MIT. CLIProxyAPI is a separate project under its own license.
