# Finding report template

A general, honest report template usable for smart-contract, web/appsec, and node/protocol findings. Fill every section from the facts; do not add fluff or claims you cannot support. ASCII only, no fancy dashes. Delete the guidance in brackets.

---

# <Title: component + one-line root cause + impact>

- **Program / platform:** <program, and the exact platform you are submitting to>
- **Asset:** <exact in-scope asset: repo path, contract address, or domain>
- **Version / commit:** <deployed version or the reviewed commit; note any divergence from deployed>
- **Impact tier:** <the program's payout tier this maps to>
- **CVSS 3.1:** <vector> = <score> (<severity>)  [set honest base metrics; see methodology/05]
- **CWE:** <most precise CWE; add the parent CWE if relevant>

## Summary
[1-2 sentences: the affected component, how an unauthenticated/unprivileged attacker triggers it, and the concrete consequence. Name the mechanism, not the marketing.]

## Preconditions (disclose honestly)
[List every condition required. If any is a privileged action or an operator step, say so plainly here. An honest caveat up front protects your credibility far more than a hidden one costs. If there are none beyond "the target is running with default config," say that.]

## Affected code
[Quote the exact vulnerable lines with file and function. Show the guard that is missing or bypassed. If the fix is one line, the bug is one place.]

## Steps to reproduce
**Setup:** [preconditions as concrete commands: create a low-priv user, stage data, connect as a peer, etc.]
**Execution:** [the exact payload / request / transaction / message. Attach any script longer than ~20 lines.]
**Verify impact:** [what the triager should observe: logs, latency, balances, crash, response. Quantify it.]

## Impact
[Map to the payout tier. State only the CIA categories actually affected, each with High/Low and one sentence. For a DoS, quantify (requests to degrade, amplification factor, resources exhausted). Note Scope=Changed only if genuinely true, and explain why.]

| Prerequisite | Consequence |
| :--- | :--- |
| <what must be true; privilege level, network access, ports> | <the direct result: theft/freeze/crash/exfil/bypass> |

## Payability self-check (do not submit unless all yes; delete before sending)
- [ ] Unprivileged/unauthenticated trigger, no trusted-role step in the path
- [ ] Works even when the operator follows the runbook perfectly
- [ ] Attacker controls the size/count/frequency that drives the impact
- [ ] Material, listed-tier impact (not dust/self-harm/slow-single-request)
- [ ] Not known / not documented-as-accepted / not a duplicate
- [ ] Adversarially verified: a skeptic could not refute it

## Recommended fix
[The smallest change that eliminates the defect, as a diff or a precise instruction. Then one defense-in-depth suggestion.]

## Notes
[Reviewed reference vs deployed version. Any materiality bounds. Offer a local-fork/authorized PoC on request. Do not include anything that discloses an unrelated unpatched issue.]
