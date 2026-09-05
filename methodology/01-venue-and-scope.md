# Venue and Scope: verify the target can pay BEFORE you hunt

The fastest way to waste days is to find a real bug in something out of scope, on the wrong platform, or already fixed/deprecated. Do this step first, every time.

## 1. Which program, which platform, which asset list

A single project often runs MULTIPLE bounty programs (for example a self-hosted or HackerOne program AND an Immunefi program) with DIFFERENT asset lists. A finding valid on one platform can be entirely out-of-scope on the other, and will be closed on arrival.

Action: open the actual submission form's asset dropdown for the platform you intend to use, and confirm your exact target (repo path, contract, domain) is selectable there. If it is not listed, you are on the wrong platform or it is out of scope. Do not assume that "the project has a bounty" means "this asset is covered here."

## 2. Deployed-version applicability

Bounties pay for impact on funds/assets at risk in a LIVE deployment. Confirm:

- The contract/binary/service is actually deployed and holds value or serves traffic NOW (check on-chain balances/addresses, or that the endpoint is live on a default install).
- It is not a deprecated or migrated-away version. A component can still hold residual value yet have its vulnerable path permanently disabled (for example a lifecycle flag that can never be re-enabled), which makes a finding non-exploitable on the deployment even though the source is "in scope."
- The source you audit matches what is deployed. If the in-scope reference is a moving branch that is ahead of the deployed release, a finding in new code is only payable if that code is deployed. Diff the audited reference against the deployed version and note divergence per finding.
- "Primacy of Impact" style rules (impact on a deployed asset can qualify even if the exact file is not enumerated) still require real, on-chain/production impact. Do not rely on them to rescue out-of-scope or undeployed code.

## 3. Map payout tiers to impact classes, hunt only what pays

Read the program's severity/reward table and enumerate the concrete impacts it pays for. Scope your hunt to those impacts only.

- Blockchain-node programs typically pay for: remote code execution, private-key leakage, and denial of service via the P2P layer, the RPC/API, or the protocol (a crafted transaction/block). Each maps to a subsystem (see `../domains/protocol-node/README.md`).
- Smart-contract programs typically pay for: direct theft (at-rest or in-motion), permanent freezing of funds, protocol insolvency, price/data misreporting, governance manipulation, unbounded resource consumption. Standard exclusions: attacks requiring privileged access, centralization risk, best-practice/informational, and issues requiring unlikely user interaction.

## 4. Submission mechanics that matter

- **Weakness / CWE**: pick the most precise CWE. For a bypassed throttle: CWE-770 (Allocation of Resources Without Limits or Throttling); its broader parent is CWE-400 (Uncontrolled Resource Consumption). Mention the parent CWE when relevant.
- **CVSS**: set honest base metrics; environmental modifiers (CR/IR/AR) usually come from the program's asset config and you do not control them. See `05-cvss-and-severity.md`.
- **Submission limits**: some platforms cap reports (for example one report per 24 hours for a new researcher; a confirmed+paid report often returns the slot). Do not spend a scarce slot on a gated or contested finding. Submit your strongest first.

## Checklist

- [ ] Exact asset is selectable in the target program's submission form on the platform I will use.
- [ ] The code is deployed, active, and holds value / serves traffic now.
- [ ] Audited reference matches (or I have diffed it against) the deployed version.
- [ ] My intended impact is a listed payout tier.
- [ ] I know the CWE, the CVSS I will claim, and the submission-limit situation.
