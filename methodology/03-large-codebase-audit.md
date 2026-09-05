# Auditing Huge Codebases (clone-on-a-remote-host + bundle + split + fan-out)

Smart-contract targets are small (a bundle of a few files). Node/protocol/monorepo targets are not: a full blockchain node or a large server can be hundreds of thousands of lines across many modules. You cannot bundle that into one review, and you should not fill local disk with a large repo plus a multi-gigabyte build cache. This is the pattern that works.

## Principle: heavy state on a remote host, small bundles local

- Clone the repo and run all heavy tooling (git, grep/ripgrep, build, static analyzers, fuzzers) on a remote host (a VPS or a dev box).
- Pull only small, per-subsystem SOURCE BUNDLES to local scratch (a few hundred KB to about 1 MB each). Subagents read the local bundle; the full repo and any build artifacts never touch the local machine.
- Keep bundles in ephemeral system scratch, not tracked project storage. (Never commit any of this; see the repo `.gitignore`.)

## Steps

### 1. Establish remote access
```
ssh -i <key> -o BatchMode=yes -o ConnectTimeout=8 -o StrictHostKeyChecking=accept-new <user>@<host> 'whoami; nproc; df -h --output=avail / | tail -1'
```
"Permission denied (publickey)" means the host is reachable but the key/user is wrong; try other keys/users. Copy any key to scratch with `chmod 600` so you do not disturb the original. Never commit keys.

### 2. Clone shallow on the remote host
```
ssh ... 'mkdir -p ~/audit && cd ~/audit && git clone --depth 1 --branch <in-scope-ref> <repo>'
```
Confirm HEAD matches the in-scope reference/commit. Size modules by line count to plan passes.

### 3. Map impact tiers to subsystems
For each payout tier, locate the responsible package(s) on the host (`find`, `grep -rn`). Fast wins first: a targeted grep for the impact's sink pattern (for example, classic memory-unsafe/deserialization/exec sinks for an RCE tier). Beware grep flag mistakes (for example, a flag that silently expects an argument) that make a scan return nothing; verify your grep actually ran before trusting a zero result.

### 4. Build a per-subsystem bundle on the host, pull it local
```
ssh ... 'cd ~/audit/repo; : > /tmp/sub.md; for f in $(find <subsystem> -name "*.<ext>" | sort); do
   printf "### %s\n\x60\x60\x60\n" "${f#*/repo/}" >> /tmp/sub.md; cat "$f" >> /tmp/sub.md; printf "\n\x60\x60\x60\n" >> /tmp/sub.md; done'
ssh ... 'cat /tmp/sub.md' > <local-scratch>/sub.md
```
Also make the FULL repo reachable to agents on demand: give them the ssh command template so a finder/skeptic can `ssh ... 'grep -rn "Symbol" ~/audit/repo'` and `ssh ... 'sed -n "A,Bp" <path>'` for helper/interface/definition files not in the bundle.

### 5. Split the bundle into review groups
Split by file markers into N groups (roughly 2k-6k lines each), round-robin for balanced size. One finder per group.

### 6. Run the engine per subsystem, sequentially
One subsystem (impact tier) per pass. Sequence passes rather than running all at once, so a small remote host is not thrashed by dozens of agents connecting concurrently. Each pass is the find-then-verify engine from `02-multi-agent-adversarial.md`, with a bug-class checklist tuned to that tier.

## Notes
- A toolchain/build on the host is only needed to compile a PoC or run a static analyzer (CodeQL/Semgrep) or fuzzer. Pure code review needs read/grep only.
- To quantify a DoS for the report, measure response latency/availability against the target during controlled testing (only on hosts you are authorized to test).
- Clean up: leave the repo/bundles on the remote host; local scratch is ephemeral. Nothing large lands on local storage, and nothing from the target repo is committed to this project.
