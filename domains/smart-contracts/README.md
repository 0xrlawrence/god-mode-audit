# Domain pack: Smart contracts (pashov engine)

Upstream: github.com/pashov/skills (the `solidity-auditor` skill). Fetched by `setup.sh` to `upstream/pashov-skills/` (git-ignored, not redistributed here). Governed by the upstream's license.

## What it is
A 12-lens adversarial multi-agent audit engine for EVM/Solidity. It spawns one attacker-agent per lens over the in-scope source, dedups, runs four judging gates, and emits a report.

The 12 lenses: math-precision, access-control, economic-security, execution-trace, invariant, periphery, first-principles, asymmetry, boundary, numerical-gap, trust-gap, flow-gap.

The four judging gates: attack-execution, reachability, trigger, impact. Plus a do-not-report list (admin-can-rug, self-harm, standard tradeoffs, out-of-scope).

## How it maps to the God Mode Audit pipeline
- It IS the FIND + DEDUP + GATE engine (`../../methodology/02-multi-agent-adversarial.md`) for EVM targets.
- Wrap it with the God Mode Audit additions: run `01-venue-and-scope` first, apply the `00-payability-gate` to its output, and add the adversarial VERIFY phase (spawn skeptics to refute each finding) before you trust a result.
- For non-EVM chains, pair with the Trail of Bits chain-specific scanners (see `../trailofbits/README.md`).

## Use
After `./setup.sh`, invoke the pashov solidity-auditor skill from `upstream/pashov-skills/solidity-auditor/` per its own instructions, pointing it at the in-scope `.sol` files. Then feed its findings and leads through the payability gate.
