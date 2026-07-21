#!/usr/bin/env node
/**
 * npm postinstall: ensure bin is executable and optionally bootstrap CLIProxyAPI.
 *
 * Set CLAUDEX_POSTINSTALL_SETUP=1 to also run `claudex setup` (downloads CLIProxyAPI).
 * Default is quiet — setup runs on first `claudex` invocation.
 */
const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const root = path.resolve(__dirname, "..");
const bin = path.join(root, "bin", "claudex");

try {
  fs.chmodSync(bin, 0o755);
} catch (err) {
  // Windows / restricted FS — ignore
}

if (process.env.CLAUDEX_POSTINSTALL_SETUP === "1") {
  const r = spawnSync(bin, ["setup"], { stdio: "inherit", env: process.env });
  process.exit(r.status || 0);
}

if (process.env.npm_config_global === "true" || process.env.npm_config_global === true) {
  // Soft hint once on global install
  console.log("");
  console.log("claudex: installed. Next:");
  console.log("  claudex setup     # download CLIProxyAPI (auto on first run too)");
  console.log("  claudex login     # Codex OAuth");
  console.log("  claudex");
  console.log("");
}
