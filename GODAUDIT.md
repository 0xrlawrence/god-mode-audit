# GODAUDIT: the unified vulnerability-research playbook

One operating procedure that combines four knowledge bases with a payability-first methodology. Read `README.md` for the overview and `methodology/00-payability-gate.md` first.

The single most important idea: **a real bug is not the same as a payable one.** Most of this playbook exists to close that gap.

The four packs (fetched by `setup.sh` into `domains/<pack>/upstream/`, never redistributed here):

- **smart-contracts** (pashov solidity-auditor): a 12-lens adversarial multi-agent engine for EVM/Solidity, four judging gates, and a report format.
- **strix** (usestrix/strix): an autonomous-pentest knowledge base. ~30 vulnerability-class playbooks, recon, coordination, scan modes, and an analysis layer: counterevidence, severity calibration, source-aware discovery, fix verification.
- **web-appsec** (skraft9): cheatsheets (SQLi, XSS, SSRF, RCE, auth bypass, dangerous functions), recon scripts, attacker mindset.
- **trailofbits** (trailofbits/skills): 42 professional audit skills. Multi-chain vuln scanners, the testing handbook (fuzzing/harness/coverage), constant-time and crypto, variant analysis, static analysis and rule authoring, triage, and the trailmark audit toolkit.

Plus the original **playbook** (`methodology/`, `domains/protocol-node/`): the connective tissue.

---

## The pipeline (run in order)

```
0. TARGET     pick a program + asset that can pay        (methodology/01-venue-and-scope.md)
1. SCOPE      confirm asset/platform/deployed version    (methodology/01-venue-and-scope.md)
2. MAP        impact tiers -> subsystems -> bug classes  (domain packs + protocol-node)
3. STAGE      for huge codebases, clone on a VPS, bundle (methodology/03-large-codebase-audit.md)
4. FIND       fan out N lenses/finders per subsystem     (methodology/02-multi-agent-adversarial.md)
5. VERIFY     adversarially refute every candidate       (methodology/02 + strix counterevidence)
6. GATE       run the payability gate; drop what fails   (methodology/00-payability-gate.md)
7. SCORE      honest CVSS + severity, no over-claim      (methodology/05-cvss-and-severity.md)
8. REPORT     write it; ASCII only; disclose caveats     (templates/)
```

Steps 0-1 come first for a reason: the fastest way to waste a week is to find a real bug in something out of scope, on the wrong platform, or already fixed/deprecated.

---

## Step 0-1: Target and scope (do this FIRST)

Read `methodology/01-venue-and-scope.md`. The rules that matter:

- **Confirm the exact asset is in the program's list, on the platform you will submit to.** A single project often runs multiple programs (for example a self-hosted HackerOne program AND an Immunefi program) with DIFFERENT asset lists. A finding valid on one platform can be out-of-scope on the other. Open the actual submission form's asset dropdown and confirm your target is selectable there.
- **Confirm deployed-version applicability.** Bounties pay for impact on funds/assets at risk in a live deployment. A bug in a deprecated/migrated contract, or in branch code that is not deployed, is not payable even if the source repo is "in scope." Check deployed addresses, versions, and migration status on-chain.
- **Map the program's payout tiers to concrete impact classes** and only hunt impacts that pay.

---

## Step 2: Map impact tiers to subsystems to bug classes

Pick the domain pack that matches the target:

- **Smart contracts / DeFi** -> `domains/smart-contracts/` (pashov 12 lenses) for EVM; add `domains/trailofbits/` scanners for non-EVM chains (Solana, Cairo, Cosmos, Substrate, Algorand, TON).
- **Web app / API / cloud / SaaS** -> `domains/web-appsec/` + strix vulnerability playbooks + strix technologies/frameworks/protocols/cloud packs.
- **Blockchain node / protocol implementation (Java/Go/Rust/C++)** -> `domains/protocol-node/` (impact-tier -> subsystem -> attacker-scalable bug classes); pair with Trail of Bits language-review and testing-handbook skills.
- **Crypto / constant-time / fuzzing / static analysis / variant hunting** -> `domains/trailofbits/`.

For each in-scope subsystem, enumerate the bug classes that map to a payable impact, then hunt each. Do not hunt impacts that are not in the payout table.

---

## Step 3-5: The engine (find -> verify)

Read `methodology/02-multi-agent-adversarial.md`. Same shape across all domains:

1. **Fan out finders**, each with a different lens, over the same code. Diversity beats a single thorough pass. Finders emit FINDINGS (concrete proof) or LEADS (honest, unverified trails). Leads are calibration, not failure.
2. **Dedup** by (component, function, bug-class).
3. **Adversarially verify every candidate.** Spawn a skeptic whose job is to REFUTE it: default to refuted unless a genuinely unprivileged, attacker-scalable, material path survives. Use strix counterevidence as the refutation discipline. This is where most "real but not payable" findings die, and that is the point.

Run finders and verifiers as parallel subagents. Adversarial verification is not optional.

---

## Step 6: The payability gate

Read `methodology/00-payability-gate.md`. A finding is submittable only if ALL hold:

1. **Unprivileged / unauthenticated trigger.** No admin/owner/governance action in the required path.
2. **No operator-error dependency.** It works even when the operator follows the runbook perfectly.
3. **Attacker-scalable.** The attacker controls the size/count/frequency that drives the impact.
4. **Material impact in the payout table.** Not dust, self-harm, or a slow single request.
5. **Not already known / documented-as-accepted / duplicate.**

The strongest findings are *bypassed protections* (a guard that exists but does not fire) rather than *missing* ones.

---

## Step 7-8: Score and report

- **CVSS honestly** (`methodology/05-cvss-and-severity.md`, strix severity calibration). Set honest base metrics; do not game Scope/CIA to inflate. Programs that pay by their own tier table assess at the tier level regardless.
- **Write the report** with a template (`templates/`). Lead with the asset + exact version/commit; disclose every precondition up front; quote the vulnerable code; give a one-line fix; provide a concrete PoC or numeric trace. ASCII only, no fancy dashes.

---

## Directory map

```
god-mode-audit/
  GODAUDIT.md                  this file
  README.md                    overview + quickstart
  ACKNOWLEDGEMENTS.md          upstreams + licenses
  LICENSE                      MIT (original material only)
  setup.sh                     clones the four knowledge bases into domains/*/upstream/
  methodology/                 the connective tissue (original)
    00-payability-gate.md
    01-venue-and-scope.md
    02-multi-agent-adversarial.md
    03-large-codebase-audit.md
    04-attacker-mindset.md
    05-cvss-and-severity.md
  domains/                     per-pack index (content fetched by setup.sh)
    smart-contracts/README.md
    strix/README.md
    web-appsec/README.md
    trailofbits/README.md
    protocol-node/README.md    original taxonomy
  templates/
    finding-report.md
```
