# Domain pack: Trail of Bits skills

Upstream: github.com/trailofbits/skills (CC BY-SA 4.0). Fetched by `setup.sh` to `upstream/tob-skills/` (not redistributed here). Because it is ShareAlike, any redistribution of that material must remain BY-SA and carry attribution, which is exactly why God Mode Audit references it instead of vendoring it.

42 plugins / ~85 skills, each at `upstream/tob-skills/plugins/<plugin>/skills/<skill>/SKILL.md` with its `resources/`/`references/` alongside. This is the deepest, most authoritative layer. Below, skills are grouped by where they plug into the God Mode Audit pipeline (`../../GODAUDIT.md`). Highest-leverage for bounty work marked (*).

## Stage 2 MAP + Stage 4 FIND (domain vuln knowledge)
Multi-chain smart-contract scanners in `building-secure-contracts/` extend the pashov EVM engine to other chains:
- solana, cairo (Starknet), cosmos (+ CosmWasm/IBC/EVM/state pattern packs), substrate, algorand, ton, token-integration-analyzer (*), each with a `resources/VULNERABILITY_PATTERNS.md`; plus code-maturity-assessor, guidelines-advisor, secure-workflow-guide, audit-prep-assistant for scoping/maturity.

Language / binary review:
- c-review (*), rust-review (*), modern-cpp, modern-python, dwarf-expert (debug info), dimensional-analysis (unit/scale bugs), entry-point-analyzer (*) (enumerate attacker-reachable entry points), audit-context-building (*) (source-aware whole-function context; pairs with strix source-aware discovery).

Config / supply-chain / crypto:
- supply-chain-risk-auditor (*), insecure-defaults, sharp-edges (dangerous API footguns), agentic-actions-auditor (*) (CI/CD + GitHub Actions injection vectors), firebase-apk-scanner, constant-time-analysis (*) and zeroize-audit (*) (crypto side-channels + secret wiping = the key-leak tier).

## Stage 4-5 FIND + VERIFY (variant hunting + adversarial)
- variant-analysis (*) and trailmark variant-neighborhood (*): after a confirmed bug, systematically find its siblings.
- differential-review (*): review a diff/PR for introduced bugs (pairs with strix diff scan mode).
- spec-to-code-compliance: check code against a spec.
- second-opinion (*), fp-check (*) (false-positive filter), vulnerability-triage-brocards (*): extra skeptic lenses that reinforce the mandatory adversarial verify + payability gate.

## Stage 5 VERIFY via testing (PoC + confirmation)
- testing-handbook-skills/ (*): harness-writing, libfuzzer, aflpp, libafl, cargo-fuzz, atheris (Python), ruzzy (Ruby), ossfuzz, coverage-analysis, fuzzing-dictionary, fuzzing-obstacles, address-sanitizer, constant-time-testing, wycheproof (crypto vectors). Turn a code-review lead into a runnable PoC.
- property-based-testing, mutation-testing.

## Static analysis + rules
- static-analysis/ (*): codeql, semgrep, sarif-parsing; semgrep-rule-creator (*), semgrep-rule-variant-creator, yara-authoring. Fast first-pass sink hunting across a large codebase (pairs with the grep step in `../../methodology/03-large-codebase-audit.md`).

## Stage 8 REPORT + diagrams
- trailmark/ (*): audit-augmentation, finding-triage, review-gate, structural, summary, slicing-code-context, diagramming-code, crypto-protocol-diagram, mermaid-to-proverif (protocol diagram -> ProVerif model), vector-forge, genotoxic, graph-evolution.
- writing-lean-proofs: formal (Lean) proofs for critical properties.

## Meta / workflow utilities
gh-cli, github-triage, git-cleanup, open-sourcing, devcontainer-setup, goal-prompt, code-improver, burpsuite-project-parser.

## How this composes
- ToB building-secure-contracts + pashov = full multi-chain smart-contract coverage.
- ToB constant-time/zeroize/wycheproof + strix crypto + skraft9 = the crypto / key-leak tier.
- ToB variant-analysis + fp-check + vulnerability-triage-brocards + strix counterevidence = the strongest VERIFY + payability-gate stage.
- ToB testing-handbook is how you turn a code-review DoS/memory lead into a runnable PoC for the report.
