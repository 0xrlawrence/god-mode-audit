# Domain pack: web-appsec (skraft9)

Upstream: github.com/skraft9/vulnerability-research. At time of import it had NO explicit license (all rights reserved), so it is referenced only and must NOT be redistributed. Fetched by `setup.sh` to `upstream/skraft9/` for personal research use.

## What it is
A practical web/appsec research kit:

- **cheatsheets/**: sqli, xss, ssrf, rce (command injection), authentication_bypass, dangerous_functions (white-box source-review patterns for C/PHP/Python/Java), reverse_engineering (GDB/Ghidra), linux_commands.
- **methodology/mindset_and_tips.md**: the attacker-mindset guide distilled in `../../methodology/04-attacker-mindset.md`.
- **custom_scripts/**: recon.sh (subdomain enum + live-host detection), ffuf_recon.sh (directory/param fuzzing), victim_monitor.py (measures latency/availability during DoS testing to quantify impact).
- **templates/**: a vulnerability report template.

## How it maps to the pipeline
- **FIND (web):** the cheatsheets are payload/detection references for the strix vulnerability lenses. `dangerous_functions.md` is a fast white-box grep guide for a source review.
- **STAGE/recon:** the custom_scripts automate asset discovery and fuzzing.
- **VERIFY/impact:** victim_monitor.py quantifies a DoS for the report.
- **REPORT:** cross-reference with `../../templates/finding-report.md`.
