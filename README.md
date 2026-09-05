# God Mode Audit

**A unified, bounty-oriented vulnerability-research playbook.**

God Mode Audit combines four battle-tested security knowledge bases into one operating procedure, then adds the connective tissue that most methodologies leave out: how to pick a target that can actually pay, how to run a multi-agent audit on codebases far too large for one context, and, above all, how to tell a *real* bug from a *payable* one so you stop getting technically-correct reports closed.

It is written for AI-assisted auditing (Claude Code, Codex, and similar agentic tools) but every document is plain markdown you can read and apply by hand.

> Ethical use only. This is for authorized security testing, bug-bounty programs, CTFs, and education. Do not test systems you do not have permission to test.

---

## The one idea that matters most

**Finding a real bug and finding a payable bug are different things.** Most of this playbook exists to close that gap.

A large fraction of technically-correct vulnerability reports get closed as *informational*, *by-design*, *duplicate*, or *out-of-scope*. They get closed for reasons that have nothing to do with whether the bug is real:

- it needs a privileged/admin action to trigger,
- it only works if the operator misconfigures something,
- the impact is bounded by state the attacker does not control,
- it is dust / self-harm / already known,
- or it was submitted against the wrong asset or the wrong platform.

God Mode Audit encodes those failure modes as an explicit, up-front **payability gate** (`methodology/00-payability-gate.md`) so you filter for them *before* you write a report, not after a triager closes it.

---

## What is combined

| Pack | Source | What it brings |
| :--- | :--- | :--- |
| **smart-contracts** | pashov solidity-auditor | A 12-lens adversarial multi-agent engine for EVM/Solidity, four judging gates, and a report format. |
| **strix** | usestrix/strix | An autonomous-pentest knowledge base: ~30 vulnerability-class playbooks, recon, coordination, scan modes, and an analysis layer (counterevidence, severity calibration, source-aware discovery, fix verification). |
| **web-appsec** | skraft9/vulnerability-research | Web/appsec cheatsheets (SQLi, XSS, SSRF, RCE, auth bypass, dangerous functions), recon scripts, and an attacker-mindset guide. |
| **trailofbits** | trailofbits/skills | 42 professional audit skills: multi-chain vulnerability scanners, the testing handbook (fuzzing/harness/coverage), constant-time and crypto, variant analysis, static analysis and rule authoring, triage, and the trailmark audit toolkit. |
| **playbook** | original (this repo) | The connective tissue: the payability gate, venue/scope verification, the multi-agent adversarial engine generalized, large-codebase-on-a-VPS fan-out, honest CVSS, and a blockchain-node/protocol domain pack. |

This repository ships **only the original playbook**. The four packs are third-party and under their own licenses (Trail of Bits is CC BY-SA, skraft9 has no license, strix is Apache-2.0), so they are **referenced, not redistributed**. `setup.sh` clones them onto your machine. See `ACKNOWLEDGEMENTS.md`.

---

## Quickstart

```bash
git clone https://github.com/0xrlawrence/god-mode-audit
cd god-mode-audit
./setup.sh            # clones the four knowledge bases into domains/*/upstream/ (git-ignored)
# then read:
open GODAUDIT.md      # the unified pipeline
open methodology/00-payability-gate.md   # read this first
```

---

## The pipeline

`GODAUDIT.md` is the full playbook. In brief, run these in order:

```
0. TARGET   pick a program + asset that can actually pay
1. SCOPE    confirm asset + platform + deployed version BEFORE hunting
2. MAP      payout tiers -> subsystems -> concrete bug classes
3. STAGE    for huge codebases: clone on a VPS, bundle, split
4. FIND     fan out many diverse lenses / finders in parallel
5. VERIFY   adversarially refute every candidate (default: refuted)
6. GATE     run the payability gate; drop what fails
7. SCORE    honest CVSS + severity, no over-claim
8. REPORT   write it; disclose caveats up front; one-line fix; PoC
```

Steps 0 and 1 come first on purpose. The fastest way to waste a week is to find a real bug in something out of scope, on the wrong platform, or already fixed/deprecated.

---

## The payability gate (summary)

A finding is submittable only if ALL of these hold (details in `methodology/00-payability-gate.md`):

1. **Unprivileged / unauthenticated trigger** - no admin/owner/governance step in the required path.
2. **No operator-error dependency** - it works even when the operator follows the runbook perfectly.
3. **Attacker-scalable** - the attacker controls the size/count/frequency that drives the impact (not something bounded by state they do not control).
4. **Material impact in the payout table** - theft, permanent freeze, RCE, DoS, key leak; not dust or self-harm.
5. **Not already known / documented-as-accepted / duplicate**.

Bonus rule: a **bypassed** protection (a guard that exists but does not fire) is a far stronger report than a **missing** one (a guard you think should be added).

---

## The engine (find, then adversarially verify)

The core loop is domain-independent; only the lenses change:

```
FIND (parallel diverse finders) -> DEDUP -> VERIFY (parallel adversarial skeptics) -> GATE -> report
```

- **Find** with many different lenses over the same code (the 12 pashov lenses for contracts; one finder per vuln class for web; a per-group bug-class checklist for huge codebases). A finding needs concrete proof; without it, it is an honest *lead*, not a finding.
- **Verify** by spawning skeptics whose only job is to refute the finding. Default to refuted unless an unprivileged, attacker-scalable, material path survives. This is where most "real but not payable" findings die, and that is the point.
- **Gate** the survivors, promote leads only with a full chain or multi-finder convergence.

See `methodology/02-multi-agent-adversarial.md`.

---

## Repository layout

```
god-mode-audit/
  GODAUDIT.md                  the unified 8-step playbook
  README.md                    this file
  ACKNOWLEDGEMENTS.md          upstreams + their licenses
  LICENSE                      MIT (original material only)
  setup.sh                     clones the four knowledge bases locally
  methodology/                 the connective tissue (original)
    00-payability-gate.md        submittable vs closed (READ FIRST)
    01-venue-and-scope.md        confirm program/asset/platform/version first
    02-multi-agent-adversarial.md find -> dedup -> adversarially verify
    03-large-codebase-audit.md   clone-on-VPS + bundle + split + fan-out
    04-attacker-mindset.md       mindset synthesis
    05-cvss-and-severity.md      honest scoring
  domains/                     per-pack index + how to use (content fetched by setup.sh)
    smart-contracts/README.md    pashov EVM engine
    strix/README.md              strix knowledge base
    web-appsec/README.md         skraft9 web/appsec kit
    trailofbits/README.md        42 ToB skills mapped to the pipeline
    protocol-node/README.md      original: blockchain-node/protocol impact-tier taxonomy
  templates/
    finding-report.md            a general, honest finding-report template
```

---

## Design principles

- **Payability over cleverness.** Most of the craft is knowing what NOT to submit.
- **Adversarial by default.** Every finding must survive a skeptic that is trying to kill it.
- **Honesty is strategy.** Disclose preconditions and materiality bounds up front; an over-claimed Critical that gets downgraded costs you credibility for the next report.
- **Respect upstreams.** Reference, do not relicense. Fetch third-party knowledge from its source.
- **Coordinated disclosure.** Never publish an unpatched, unresolved vulnerability. Keep live findings out of any public repository.

---

## Contributing

Issues and PRs welcome for the original playbook (methodology, taxonomies, templates). Do not submit third-party content for vendoring here; add it as a reference in `setup.sh` and `ACKNOWLEDGEMENTS.md` instead. Never include live/unpatched vulnerability details or client material.
