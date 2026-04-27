# Engineering Principles

To maintain high velocity and low technical debt, all agents must adhere to these principles. Primary goal: **Complexity Management**.

## 1. Strategic vs. Tactical Programming

- **Strategic Mindset:** Working code is not enough. The primary goal is a great design.
- **Avoid Tactical Tornadoes:** No shortcuts that introduce complexity.

## 2. Modules Should Be Deep

- **Deep Modules:** Powerful functionality through simple, narrow interfaces.
- **Shallow Modules:** Avoid modules where interface complexity approaches implementation complexity.

## 3. Information Hiding

- **Encapsulation:** Each module encapsulates specific design decisions.
- **Pull Complexity Downwards:** Module implementer suffers complexity so users don't have to.

## 4. General-Purpose vs. Special-Purpose

- **"Somewhat General-Purpose":** Design for current and near-future needs without over-specialization.
- **Clean API:** General-purpose interfaces are usually simpler and deeper.

## 5. Define Errors Out of Existence

- **Minimize Exceptions:** Design APIs so edge cases are handled naturally (e.g., return empty list vs throw null).

## 6. Comments and Documentation

Comments explain design decisions and context that cannot be inferred from code alone.

- **Describe Intent, Not Behavior:** Capture the _why_, not the _what_.
- **No Conversation Artifacts:** No debugging history or previous attempts.
- **Keep It Brief:** Every word must earn its place.
- **TODO Comments Exception:** `TODO:` permitted for intentional future work.

## 7. Avoid Overabstraction and Complexity

- **Complexity Management:** Say "no" to features that don't provide immediate, clear value.
- **Delay Factoring:** Wait for system's shape to emerge before abstracting.
- **DRY Pitfalls:** Simple repeated code > complex DRY solution.
- **Locality of Behavior:** "Put code on the thing that does the thing."
- **Simplicity Above All:** As simple as possible, but no simpler.

## 8. Prefer Declarative over Imperative

- **Focus on the "What":** Describe intent rather than execution steps.
- **Avoid the Black Box:** Declarative code provides WYSIWYG experience.
- **Predictability & Idempotency:** Declarative state is inherently idempotent.

## 9. Security & Secret Protection

- **Git Awareness:** Check for `.git` before handling secrets.
- **No Secrets in Code:** Use environment variables or secret managers.
- **Proactive Prevention:** Warn about committing secrets.

## 10. Context, Consistency, and Explicit Logic

- **Consistency is King:** Follow existing style and patterns.
- **Explicit over Implicit:** Avoid "magic," hidden side effects, global state.
- **Dependency Minimalism:** Don't add libraries for trivial tasks.
- **Read First, Write Second:** Understand existing code before adding new code.

## 11. High-Leverage Laziness

- **Work Like a Lion:** Intense, focused bursts on high-leverage problems.
- **Leverage is Everything:** Build systems that work for you.
- **The 80/20 Rule:** 80% of value comes from 20% of effort.
- **Strategic Patience:** Wait for the right, most efficient path.

## 12. Avoid Click-Ops: Config and Infrastructure as Code

- **Auditability & Declarative State:** Code is auditable, versionable, declarative.
- **Config as Code:** If it isn't in source control, it doesn't exist.

## 13. The Agent is the Interface

- **Code is the Language of Automation:** Maintain everything in code.
- **Direct Interaction:** Communicate intent through declarative configurations.

## Design Red Flags

- **Information Leakage:** Change in one place requires coordinated changes elsewhere.
- **Temporal Coupling:** Methods must be called in specific order not enforced by API.
- **Pass-Through Methods:** Method does nothing but call another with similar signature.
- **Cognitive Load:** Excessive "mental state" required to understand a function.
- **Shallow Module:** Interface nearly as complex as the logic it hides.
- **Premature Abstraction:** Factoring before system's shape is clear.
- **Watery Code:** So abstracted it's hard to grasp.
- **Hardcoded Secret:** Credentials directly in source code.
- **Clever Code:** Technically impressive but unreadable.
- **Dependency Bloat:** External libraries for simple tasks.
- **Implicit Side Effects:** Functions modify state not obvious from name/signature.

## Intellectual Integrity & Candor

**Agents are not here to be polite; they are here to be correct.**

- **Anti-Sycophancy Rule:** Never praise violations of design principles.
- **Push Back:** Counter "tactical" shortcuts with principle-based arguments.
- **Don't Trust Humans:** Act as "Strategic Anchor" for long-term maintainability.

## Code Standards

### Go

All Go code must pass `golangci-lint run ./...` without warnings.

- **Project Structure:** `cmd/` (apps), `internal/` (private), `pkg/` (public).
- **Logging:** Use structured logger (e.g., `slog`). No `fmt.Println`.
- **Standard Library:** Prefer stdlib over external dependencies.
- **Error handling**: Check all errors. Use `_` to explicitly ignore.
- **Formatting**: Run `gofmt` before committing.

### JavaScript

All JavaScript files formatted with Prettier.

- **Single quotes**, **Semicolons**, **2 space indentation**.
- Run Prettier on `assets/js/*.js` before committing.

### Markdown & Writing Style

Professional, senior-level engineering tone. No AI writing patterns.

- **No "AI-style" Formatting:** Avoid bold-beginning bullet points.
- **Formatting Standards:** Prettier (single quotes, blank lines around headers). Obsidian (WikiLinks `[[Link]]`, YAML front matter).
- **Preserve User Intent:** Save original language/structure exactly. Reread file before editing.
- **Tone & Brevity:** Concise, direct. No filler or "syrupy" politeness.
- **No Weasel Words:** No "it seems," "appears to be," "generally."
- **Short Sentences:** Prefer short, declarative sentences. Active verbs.
- **No Pseudo-Profound Dualities:** State truth directly, no "not just X, but Y."
- **Eliminate Static:** Avoid "There are," "It is," "The reason is."
- **Think Before You Write:** One thought per sentence.
- **Reader Context:** If a sentence can be misunderstood, it will be. Clarity is respect.

## Obsidian Vault: Second Brain

Use obsidian-remote skill for vault access. For vault-specific guidelines (journals, note format, tone), consult the `AGENTS.md` note in the vault. Links use `[[id]]` format, not file paths.
For quick notes, use zettel skill to capture thoughts in the inbox (0-inbox).
