# Acknowledgements and third-party licenses

God Mode Audit is a playbook that stands on the shoulders of four excellent open knowledge bases. This repository contains ONLY original methodology; it does not redistribute any of the works below. `setup.sh` clones each from its upstream into `domains/<pack>/upstream/` on your machine for personal research use. Each remains governed by its own license. Please read and honor them.

| Pack | Upstream | License | Notes |
| :--- | :--- | :--- | :--- |
| smart-contracts | github.com/pashov/skills (solidity-auditor) | see upstream repo | EVM 12-lens adversarial audit engine, judging gates, report format. |
| strix | github.com/usestrix/strix | Apache-2.0 | Autonomous pentest-agent knowledge base: vuln-class playbooks, analysis (counterevidence, severity calibration, source-aware discovery, fix verification), recon, coordination. |
| web-appsec | github.com/skraft9/vulnerability-research | no explicit license at time of import (all rights reserved) | Web/appsec cheatsheets, recon scripts, attacker mindset, report template. Cloned for personal use only; do not redistribute. |
| trailofbits | github.com/trailofbits/skills | CC BY-SA 4.0 | 42 professional audit skills: multi-chain vuln scanners, testing-handbook (fuzzing), constant-time/crypto, variant analysis, static analysis, triage, trailmark toolkit. Attribution + ShareAlike required for any redistribution of that material. |

## Why these are referenced, not bundled

- **Trail of Bits (CC BY-SA 4.0)** is copyleft. Redistributing it would require the combined work to also be BY-SA and to carry attribution; bundling it into an MIT repo would misrepresent its license. So it is referenced and fetched, never re-hosted here.
- **skraft9** ships without a license, i.e. all rights reserved. It cannot be redistributed. Referenced and fetched only.
- **strix (Apache-2.0)** and **pashov** are referenced and fetched rather than vendored, to keep this repository cleanly MIT and to always pull the latest upstream.

If you are an author of any referenced work and want a reference changed or removed, please open an issue.

## Original work

The God Mode Audit playbook (`GODAUDIT.md`), the methodology documents (`methodology/`), the domain index and taxonomy documents (`domains/*/README.md`), the templates (`templates/`), and `setup.sh` are original and MIT-licensed (see `LICENSE`).
