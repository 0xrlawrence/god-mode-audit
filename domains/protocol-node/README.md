# Domain pack: Blockchain Node / Protocol Implementations (original)

For auditing full-node / protocol implementations (Java/Go/Rust/C++): the node software behind a chain, its P2P layer, its RPC/API, its transaction/block validation, and its crypto. These are large multi-module codebases, not smart contracts, so use the huge-codebase engine (`../../methodology/03-large-codebase-audit.md`) and the find-then-verify loop (`../../methodology/02-multi-agent-adversarial.md`).

The unit of work is: **one payout-impact-tier per pass**, mapped to the responsible subsystem, hunted with a tier-specific, attacker-scalable bug-class checklist.

## Impact tiers -> subsystems -> bug classes

### RPC-API DoS (unauthenticated remote)
- **Subsystem:** HTTP / JSON-RPC / gRPC endpoint handlers + the rate limiter.
- **Bug classes:** attacker-controlled count/size driving unbounded allocation or loop; missing pagination/limit on a DB-scanning query; endpoints not covered by the rate limiter; ReDoS / parser blowup; integer overflow -> huge allocation; deep-nesting recursion -> stack overflow; unbounded response construction.
- **Gate reminder:** the magnitude must be ATTACKER-controlled. Work bounded by chain-state (for example "returns all N records") is amplification, not DoS, and gets closed. See payability gate condition 3.

### P2P network DoS (unauthenticated peer / spoofable UDP)
- **Subsystem:** the net layer (TCP message handlers, message codecs, UDP discovery, sync/fetch).
- **Bug classes:** a length/count field in a message driving unbounded allocation with no cap; missing max-message/field-size checks; unbounded per-peer queue/buffer; a malformed message throwing an uncaught exception that crashes a shared thread; UDP discovery amplification (small spoofed request -> large response to a victim); decode recursion -> stack overflow; sync/fetch abuse (cheaply request an unbounded set); missing OR bypassed per-peer rate limiting.
- **This is usually the richest tier for a code-review researcher** because a peer controls the message bytes (attacker-scalable by construction), unlike RPC reads bounded by chain state. Pay special attention to rate limiters that are registered but gated behind a condition that is false in the steady state: a bypassed protection is a stronger finding than a missing one (payability gate, bypassed-vs-missing rule).

### Protocol DoS (crafted transaction/block)
- **Subsystem:** transaction actuators/handlers, tx/block validation, the resource model (gas/energy/bandwidth accounting).
- **Bug classes:** a validation/execution loop or allocation driven by an attacker-controlled field with no cap; expensive work in the pre-fee validation path (runs on every node on broadcast, before fees) rather than post-inclusion; signature/permission verification amplification; a resource-model underprice (real cost far exceeds the charged resource); superlinear complexity with attacker-controlled n.
- **Gate reminder:** the resource model usually charges proportionally, making most paths cost-symmetric. The win is ASYMMETRY (cheap input -> disproportionate node work), ideally pre-fee. If the fee/resource charge scales with the work, it fails the gate.

### RCE (top tier) and private-key leakage
- **RCE sinks (fast triage first):** native deserialization, XML/YAML unmarshalling, script/template evaluation, process execution, reflection on attacker data, and native/FFI boundaries fed attacker input (for example a zk/crypto native library on malformed proofs). A ten-minute grep for these sinks often closes the RCE tier immediately if the project does not use them.
- **Key-leak subsystems:** the crypto module + keystore. Bug classes: predictable/reused signature nonce -> key recovery from two signatures; weak RNG for keys/nonces; signature-verification bypass -> forgery; a secret logged/serialized/in an error message; weak keystore KDF; non-constant-time secret compare with a remote timing path; parser DoS. Beware dead code (a real defect in an unreachable method is not payable) and local-only paths (an operator loading an attacker-supplied file is self-DoS, not a remote finding).

## The pass structure (worked template)

Run one pass per tier on the remote-host bundle set, sequentially:

1. RPC-API DoS pass
2. P2P DoS pass
3. Protocol DoS pass
4. RCE / key-leak pass

Expect most passes on a mature, well-hardened node to yield NO payable finding: proportional resource models defeat protocol-DoS asymmetry, chain-state bounds defeat RPC-DoS scalability, and clean codebases lack the classic RCE sinks. That is normal and correct: the payability gate is doing its job. The pass that most often yields a genuinely payable, attacker-scalable finding is the P2P pass, because the attacker controls the message bytes and thus the magnitude. Hold every candidate to the gate in `../../methodology/00-payability-gate.md` and adversarially verify it before you believe it.

Pair this pack with Trail of Bits `c-review`/`rust-review`/`entry-point-analyzer` (language + entry-point analysis) and the `testing-handbook` (to build a runnable PoC for a confirmed crash), and use `../../methodology/03-large-codebase-audit.md` for the remote-host bundling logistics.
