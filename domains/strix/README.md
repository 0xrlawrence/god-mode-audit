# Domain pack: strix (autonomous pentest knowledge base)

Upstream: github.com/usestrix/strix (Apache-2.0). Fetched by `setup.sh` to `upstream/strix/` (not redistributed here).

## What it is
An open-source autonomous penetration-testing agent. For God Mode Audit we use its KNOWLEDGE, which lives under `upstream/strix/strix/skills/`:

- **vulnerabilities/** (~30 class playbooks): idor, ssrf, ssti, sqli/nosql, xss, csrf, insecure deserialization, path traversal/LFI/RFI, xxe, prototype pollution, mass assignment, race conditions, business logic, http request smuggling, header injection, open redirect, subdomain takeover, argument injection, insecure file uploads, weak password detection, information disclosure, broken function-level authorization, browser security, semantic confusion, agentic-system security, LLM prompt injection, RCE, authentication/JWT.
- **analysis/** (the highest-value layer): counterevidence, severity_calibration, source_aware_discovery, fix_verification.
- **coordination/** (root_agent, source_aware_whitebox), **scan_modes/** (deep, diff, standard, quick), **reconnaissance/**, **technologies/** (auth0, firebase, supabase, active_directory, electron, grafana/prometheus, llm apps), **frameworks/** (django, fastapi, nestjs, nextjs), **protocols/** (graphql, oauth), **cloud/** (aws, gcp, azure, kubernetes), **tooling/** (nmap, nuclei, ffuf, httpx, katana, naabu, subfinder, sqlmap, semgrep, hurl, hypothesis, python).
- The agent operating philosophy: `upstream/strix/strix/agents/prompts/system_prompt.jinja`.

## How it maps to the pipeline
- **FIND (web/API/cloud):** one finder per relevant `vulnerabilities/` class, plus the technologies/frameworks/protocols/cloud packs for the target's stack.
- **VERIFY:** `analysis/counterevidence.md` is the refutation discipline for the mandatory adversarial verify phase.
- **SCORE:** `analysis/severity_calibration.md` for honest severity.
- **Mindset / white-box:** `analysis/source_aware_discovery.md` + `coordination/source_aware_whitebox.md`.
