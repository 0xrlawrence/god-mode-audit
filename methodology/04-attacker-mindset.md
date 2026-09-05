# Attacker Mindset (skraft9 + strix synthesis)

Distilled from skraft9's mindset guide and the strix agent operating philosophy. Read the originals after `setup.sh`: `../domains/web-appsec/upstream/skraft9/methodology/mindset_and_tips.md` and the strix system prompt under `../domains/strix/upstream/strix/`.

## Core disposition
- You are searching for things that are NOT supposed to be there. You can sink days into a target and walk away with nothing. Failing repeatedly is inherent to the process, not a signal to stop.
- Trust your discomfort. If an application, contract, or node responds to an input in an unexpected way (a slight delay, a strange error code, an off-by-one in a response), keep pulling that thread. Anomalies are where bugs live.
- Hunt where others are not. Duplicates sting but confirm you are reading the right things; sweep for sibling instances of a confirmed bug and apply the pattern to future hunts.

## Preparation beats cleverness
- Pick targets in architectures you already understand deeply. Time spent reading the developer docs, API specs, admin guides, and the code/flow is never wasted.
- Read past advisories and patches for the target and its class. A patch diff teaches you exactly what a vulnerable path looks like versus a fixed one. Sources: GitHub Advisory Database, Talos, Tenable, Zero Day Initiative.
- Look for hidden endpoints, legacy/deprecated paths, and complex logic chains. Old code that is still reachable is a rich seam.

## Source-aware, white-box discovery (strix)
- When you have source, use it: trace attacker-controlled input from entry point to sink. The strix analysis pack (source-aware discovery, white-box coordination) formalizes this.
- Enumerate entry points first (what can an unauthenticated caller reach), then follow the data. A bug at a sink only matters if a reachable, unprivileged path feeds it attacker-controlled data.

## The discipline that makes findings pay
- Adversarially verify your own work (strix counterevidence): before believing a finding, try hard to refute it.
- Calibrate severity honestly (strix severity calibration): do not inflate. A credible Medium beats an over-claimed Critical that gets downgraded and dents your standing with the triager.
- Verify fixes and non-regressions when reporting or re-testing (strix fix verification).
- Run the payability gate (`00-payability-gate.md`) on every candidate. Most of the craft is knowing what NOT to submit.

## Cadence
- Show up every week. Real findings take hundreds to thousands of focused hours. Practice against intentionally-vulnerable targets to keep the reps up between live hunts.
