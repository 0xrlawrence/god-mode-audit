# The Multi-Agent Adversarial Engine

The core hunting loop, shared across all domains. Only the lenses/bug-classes change per domain. It is the pashov multi-agent model generalized, with strix's counterevidence discipline bolted on as a mandatory verify phase.

## Shape

```
FIND (parallel finders)  ->  DEDUP  ->  VERIFY (parallel adversarial skeptics)  ->  GATE  ->  report
```

Run finders and verifiers as concurrent subagents (the pashov engine does this directly; for anything else use a workflow with a Find phase and a Verify phase). Never let one agent both find and bless its own finding: separation of finder and skeptic is the whole point.

## Phase 1: FIND (diverse lenses, not one big scan)

Spawn many finders, each with a DIFFERENT lens, over the same code. Diversity beats a single thorough pass because different lenses surface different bug shapes.

- **Smart contracts:** the 12 pashov lenses (math-precision, access-control, economic-security, execution-trace, invariant, periphery, first-principles, asymmetry, boundary, numerical-gap, trust-gap, flow-gap).
- **Web/API/cloud:** one finder per vuln class from the strix vulnerability playbooks (idor, ssrf, ssti, sqli, xss, deserialization, race conditions, business logic, mass assignment, prototype pollution, ...) plus the skraft9 cheatsheets.
- **Node/protocol (huge codebase):** split the subsystem into groups (see `03-large-codebase-audit.md`) and give each finder a bug-class checklist tied to a payout tier (see `../domains/protocol-node/README.md`).

Finder output discipline:
- A **FINDING** has file, function, root-cause (one sentence), minimal fix, and concrete PROOF (numbers, a trace, or quoted code).
- Without proof it is a **LEAD**, not a finding. Leads are honest calibration, not failure. Emit them.
- Do not skim. Do not trust your first read. Trust your discomfort: if an input produces an unexpected response (a delay, an odd error), pull that thread.

## Phase 2: DEDUP

Group all candidates by (component, function, bug-class). Keep the best per group; annotate how many finders converged (multi-finder convergence is a promotion signal). Never merge across different functions. Preserve distinct fix mechanisms.

## Phase 3: VERIFY (adversarial, mandatory)

For every deduped candidate, spawn a skeptic whose ONLY job is to REFUTE it. This is where most "real but not payable" findings die, which is the goal.

Refutation discipline (strix counterevidence): default to refuted; the finding survives only if the skeptic cannot find a guard, cap, auth check, or materiality gap that breaks it. The skeptic must, concretely:

1. Trace the claimed path against the real code (read it; do not trust the finder's quote).
2. Look for the interrupting guard: a cap/limit/rate-limiter/size-check/require/modifier/try-catch on the path. Quote it if found and refute.
3. Check reachability: is the entry point actually reachable by the claimed actor on a default deployment?
4. Check the payability gate (`00-payability-gate.md`): unprivileged? no operator-error? attacker-scalable? material? not-known?

Run one skeptic for a quick pass, or three-to-five diverse skeptics (each a different lens: correctness, reachability, materiality) for high-value targets. Majority-refute kills it.

Watch for **verifier disagreement.** If some skeptics confirm and others refute the same issue, it is BORDERLINE. Do not take the confirming verdict at face value: go read the source yourself and adjudicate. Contested findings are exactly the ones triage will scrutinize hardest, so resolve the disagreement before you submit.

## Phase 4: GATE and promote

- Run survivors through the payability gate (`00-payability-gate.md`) and the pashov judging gates (attack-execution -> reachability -> trigger -> impact).
- Promote a lead to a finding only with a full exploit chain in source, or multi-finder convergence on a demoted (not refuted) issue.
- No deployer-intent reasoning: judge what the code allows, not how a deployer might use it.

## Scaling to what the target deserves

- "find any bugs" -> a few finders, single-vote verify.
- "thoroughly audit / be comprehensive" -> full lens set, three-to-five-vote adversarial verify, hand-adjudicate contested items.
- Loop-until-dry for unknown-size discovery: keep spawning finder rounds until K consecutive rounds surface nothing new; dedup each round against everything seen, not just confirmed.

## Reference implementations

- `domains/smart-contracts/` is the pashov engine (invoke the solidity-auditor skill from its upstream).
- For non-Solidity, replicate the shape with a workflow: a Find phase (finders over groups, structured output) then a Verify phase (adversarial skeptics per candidate, structured verdict). The `domains/protocol-node/README.md` pack describes how to apply this to a large node codebase.
