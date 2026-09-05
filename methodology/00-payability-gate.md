# The Payability Gate

The highest-value idea in God Mode Audit. A real bug and a payable bug are different things. This gate is the filter that separates them. Run every candidate through it BEFORE writing a report. It is stricter than a generic "is this a vuln" check because it encodes why real bounty programs CLOSE technically-correct reports.

## The five conditions (ALL must hold)

A finding is submittable only if every one of these is true:

### 1. Unprivileged / unauthenticated trigger
No admin, owner, governance key, deployer, or other trusted role appears in the required exploitation path. The attacker is an anonymous outsider (or an ordinary user).

- **Why:** bounty programs exclude "attacks requiring privileged access" and "centralization risk" almost universally. If the exploit needs a trusted role to act, it is treated as a trust assumption, not a vulnerability.
- **Pattern that fails:** the bug only manifests after a privileged setup step (an owner reconfiguring roles, running a migration, flipping a mode). Even if a third party is ultimately harmed, a required privileged step usually sinks it.
- **Nuance:** a *privileged setup* followed by an *unprivileged trigger with a third-party victim* is sometimes arguable, but it is weak. Prefer paths with no privileged step at all.

### 2. No operator-error dependency
The bug must not rely on the operator misconfiguring, forgetting a step, or deviating from the documented runbook.

- **Why:** "it breaks if the operator skips the pause / forgets to set X" is closed as operator error, not a vulnerability.
- **Test:** if your PoC contains a sentence like "assuming the operator does not X" or "if the admin forgets Y," it fails this condition. The program's answer will be "operate it correctly."

### 3. Attacker-scalable (attacker controls the magnitude)
The attacker controls the size / count / frequency that drives the impact. Impact bounded by state the attacker does not control (chain state, a config constant, a protocol cap) is usually not enough on its own.

- **Why:** a cost bounded by something outside the attacker's control cannot be amplified into a real attack; it is an efficiency smell, not a DoS/theft.
- **Pattern that fails:** an endpoint does "unbounded" work, but the amount is fixed by how much data already exists (for example "returns all N records"), not by attacker input, and it is rate-limited. That is amplification, not DoS.
- **Pattern that passes:** the per-request work is capped, but the attacker controls the FREQUENCY because a rate limit is missing or bypassed. Frequency is the attacker-controlled magnitude.

### 4. Material impact in the program's payout table
The consequence maps to a real, listed tier: direct theft, permanent freezing of funds, RCE, protocol/network DoS, private-key leakage, price/data manipulation, and so on. Not dust, not self-harm, not a single slow request.

- **Why:** self-harm-only findings are rejected; dust-level with no compounding is demoted.

### 5. Not already known / documented-as-accepted / duplicate
Sweep for prior advisories, "known edge case" code comments, prior contest findings, and sibling reports.

- **Why:** duplicates and known-issues are closed. A code comment that acknowledges or "blesses" the behavior is a strong signal the program already considered and accepted it.
- **Tooling:** GitHub Advisory Database, the project's past audits/contests, Talos/ZDI/Tenable advisories, and a grep of the code for comments like "known", "in practice this shouldn't happen", "acceptable", "edge case".

## The bypassed-vs-missing rule

Among findings that pass the gate, the strongest framing is a **bypassed protection** over a **missing** one:

- **Bypassed (strong):** "You registered a guard for X, but it is gated behind a condition that is false in the common case, so it never fires." This is a defect in existing code and is hard to dismiss.
- **Missing (weak):** "You should add a guard to X." This is a design suggestion and is easy to dismiss as by-design.

If two findings are the same impact class, the one that shows an existing protection being bypassed is the stronger report.

## Quick scorecard

Before writing, answer yes/no:

- [ ] Anonymous/unprivileged attacker can trigger it with no trusted-role step?
- [ ] Works even when the operator follows the documented runbook perfectly?
- [ ] Attacker controls the size/count/frequency that drives the damage?
- [ ] Impact is a listed payout tier (not dust/self-harm/slow-single-request)?
- [ ] Not a known issue, not documented-as-accepted, not a likely duplicate?
- [ ] (Bonus) Is it a bypassed protection rather than a missing one?

Five yeses = submit. Any no = it is a lead or an informational note, not a paid submission. Say so honestly rather than dressing it up; over-claiming a gated finding burns credibility with the triager for the next one.
