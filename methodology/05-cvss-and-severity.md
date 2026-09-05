# CVSS and Severity: score honestly

Cross-reference the strix severity-calibration pack. The goal is a score a triager will accept without a downgrade, because an over-claim costs credibility for your next report.

## Set honest base metrics, do not game them
Pick each CVSS 3.1 base metric from the actual exploit, not from the score you want:

- **Attack Vector (AV):** Network for a remote exploit; Adjacent/Local/Physical only if truly required.
- **Attack Complexity (AC):** Low if there are no special conditions to engineer; High only if a real race/precondition must be won.
- **Privileges Required (PR):** None for an unauthenticated attacker. If this is not None, re-check the payability gate: privileged findings usually do not pay.
- **User Interaction (UI):** None unless a victim must act.
- **Scope (S):** Unchanged for an impact contained to the vulnerable component. Do NOT flip to Changed to inflate; a component-level DoS is Unchanged.
- **C / I / A:** set only the ones actually impacted. A pure DoS is `C:N/I:N/A:H` (or `A:L` if only degradation). No data disclosure means `C:N`; no data tampering means `I:N`.

Worked example (an unauthenticated network denial of service): `AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H` = base 7.5 (High).

## Availability: High vs Low
- **A:H** = total loss of availability, or sustained/repeatable denial. Conventional for a DoS finding; use it when sustained exploitation denies the component's function.
- **A:L** = reduced performance / intermittent interruption. Use it if the honest impact is degradation, not a hard kill.
- Pick the one that matches your report's own materiality caveat, and keep them consistent.

## Environmental modifiers are not yours to set
On some platforms the vector shows appended CR/IR/AR (for example `.../CR:H/IR:H/AR:H`) that push the score up (for example base 7.5 to environmental 9.3 Critical). These come from the PROGRAM's asset security-requirement config, not from you. Do not lower them by falsifying base metrics, and do not treat the resulting Critical as your claim; it is the program's weighting. Note that CR/IR only move the score if the corresponding C/I impact is set; for a pure-availability DoS only AR matters.

## Severity vs payout tier
Many programs pay by their own tier table, not by CVSS. A program may pay a flat amount per impact class regardless of whether the calculator says 7.5 or 9.3. So:
- Set honest CVSS and let the form compute what it computes.
- Do not lean on the CVSS number in your narrative; lead with the mechanism and disclose the materiality bounds.
- Expect triage to assess at the tier level.

## Self-assessment rule of thumb
- Gated / operator-dependent / dust / self-harm -> informational or low; usually do not submit (see the payability gate).
- Unprivileged + attacker-scalable + material + not-known -> the real tier; submit, self-assess at the honest tier, disclose caveats up front.
