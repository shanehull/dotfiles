# Engineering Principles

To maintain high velocity and low technical debt, all agents (human or AI) must adhere to these engineering principles. These standards have been established to meet the specific requirements of our workspace, with a primary goal of **Complexity Management**.

---

## 1. Strategic vs. Tactical Programming

- **Strategic Mindset:** Working code is not enough. The primary goal is a great design. High-quality design is a proactive investment that prevents future slowdowns.
- **Avoid Tactical Tornadoes:** Do not take shortcuts to finish a feature faster if it introduces complexity. A "quick fix" is often a permanent debt.

## 2. Modules Should Be Deep

- **Deep Modules:** The best modules provide powerful functionality through a simple, narrow interface. They hide significant implementation complexity.
- **Shallow Modules:** Avoid modules where the interface is complex relative to the small amount of work it performs.
- **Goal:** Maximize the _benefit_ of the module while minimizing its _cost_ (interface complexity).

## 3. Information Hiding

- **Encapsulation:** Each module should encapsulate specific design decisions.
- **Information Leakage:** This occurs when a design decision is reflected in multiple modules. If changing one class requires changing another, the design is leaking.
- **Pull Complexity Downwards:** It is better for a module's implementation to be complex than for its interface to be complex. The **developer of the module** should suffer complexity so the **users of the module** don't have to.

## 4. General-Purpose vs. Special-Purpose

- **"Somewhat General-Purpose":** Design modules to be flexible enough to handle current needs and potential near-future needs without being overly tied to a single specific use case.
- **Clean API:** A general-purpose interface is usually simpler and deeper than a specialized one.

## 5. Define Errors Out of Existence

- **Minimize Exceptions:** Exceptions contribute significantly to complexity. Design APIs so that "edge cases" are handled naturally by the normal flow (e.g., returning an empty list instead of throwing `null` or an error).

## 6. Comments and Documentation

Comments exist to explain design decisions and context that cannot be inferred from code alone. They are NOT a dumping ground for conversation artifacts, debugging notes, or code descriptions.

- **Describe Intent, Not Behavior:** Comments should capture the _why_ behind design decisions, not describe what the code does. The code itself should be clear enough that a reader understands the mechanics without explanation. Comments explain the reasoning, constraints, or trade-offs that informed the code's structure.
- **No Conversation Artifacts:** Never include context from the development process, debugging sessions, or previous attempts. Comments should be useful to a reader encountering the code fresh, not to someone who was part of its creation. Strip away all metanarrative.
- **No Metadata or Breadcrumbs:** Do not use brackets, references to previous discussions, or context-setting information in comments. The reader does not care how the code was built; they only care how to use or maintain it.
- **Different Levels:**
  - **Interface:** Explain the _intent_ and non-obvious constraints, not the implementation mechanics.
  - **Implementation:** Justify complex logic, explain trade-offs, and clarify assumptions. Focus on "why this way" rather than "what this does."
- **Keep It Brief:** Every comment word should earn its place. If a comment is longer than the code it describes, either simplify the code or simplify the comment.
- **TODO Comments Exception:** `TODO:` comments are permitted when marking intentional work to be completed later. These should be actionable and removed when the work is done.

## 7. Avoid Overabstraction and Complexity

- **Complexity Management:** The primary job of a developer is to keep complexity at bay. Say "no" to new features and unnecessary abstractions that don't provide immediate, clear value.
- **Delay Factoring:** Don't factor code prematurely. Wait for the system's shape to emerge through actual use. Early abstractions are often wrong and create "watery" code that is hard to grasp.
- **The Pitfalls of DRY:** Don't follow DRY (Don't Repeat Yourself) at the cost of simplicity. Simple, repeated code is often better than a complex DRY solution involving callbacks, closures, or elaborate models. Prioritize **Readability over Compression**.
- **Locality of Behavior (LoB):** Prefer to "put code on the thing that does the thing." Avoid jumping between many files to understand a single behavior.
- **Admit Complexity:** Seniority is the ability to recognize and call out when a solution is becoming too complex. Admitting when code is too complicated prevents "big brain" over-engineering from being merged.
- **Simplicity Above All:** As simple as possible, but no simpler. A senior's value is in their ability to _not_ abstract everything they can.

## 8. Prefer Declarative over Imperative

- **Focus on the "What":** Prefer declarative (the desired end state) over imperative (the steps to get there). Declarative code is easier to reason about because it describes _intent_ rather than _execution_.
- **Remove Unnecessary Abstraction:** If a system already understands a declarative format (e.g., YAML, SQL, CSS), provide it directly. Don't wrap it in imperative logic or complex toggles unless you are building a discrete, versioned product for wide distribution.
- **Avoid the Black Box:** Imperative wrappers create uncertainty. Declarative code provides a "What You See Is What You Get" (WYSIWYG) experience, where the configuration in source control matches the state in the system exactly.
- **Predictability & Idempotency:** Declarative state is inherently idempotent and easier to audit. Troubleshooting is simplified because you don't need to trace execution logic or chase down facts about the environment to determine the final result.

## 9. Security & Secret Protection

- **Git Awareness:** Always check for the existence of a `.git` directory or other version control indicators before implementing or suggesting any code that handles secrets (API keys, tokens, passwords).
- **No Secrets in Code:** Never hardcode secrets. Always recommend using environment variables, `.env` files (ensure they are in `.gitignore`), or dedicated secret managers.
- **Proactive Prevention:** If a git repository is detected, explicitly warn the user about the risks of committing secrets and proactively check that sensitive files are excluded from version control.

## 10. Context, Consistency, and Explicit Logic

- **Consistency is King:** Always adhere to the existing style, naming conventions, and architectural patterns of the workspace. A project is better off being consistently "wrong" than having five different versions of "right."
- **Explicit over Implicit:** Avoid "magic," hidden side effects, and global state. Code should be explicit about its dependencies and data flow. A function should do what its name says and nothing else.
- **Dependency Minimalism:** Do not add a library for a task that can be solved with a few lines of standard, idiomatic code. Every dependency is a liability and a potential source of complexity.
- **Understand the "Why":** Never copy-paste code or apply a pattern (including these principles) blindly. If you can't explain why a piece of code exists and how it works, you shouldn't commit it.
- **Read First, Write Second:** Spend more time reading the surrounding code than writing new code. Ensure your changes fit into the existing "territory" seamlessly.

## 11. High-Leverage Laziness

- **Work Like a Lion:** Avoid "grazing" or steady, low-impact busywork. Work in intense, focused bursts to solve high-leverage problems, then step back to recalibrate and rest.
- **Leverage is Everything:** Code is the ultimate form of permissionless leverage. Focus on building systems that work for you, rather than performing tasks manually. If a task must be done more than twice, automate it or design it out of existence.
- **The 80/20 Rule:** 80% of the value comes from 20% of the effort. Identify the critical path and ignore the marginal details that add complexity without proportional value.
- **Smart vs. Busy:** Being "busy" is often a mask for a lack of priority. A "smart lazy" developer finds the path of least resistance to the most impact. They don't write more code; they find the smallest amount of code that solves the problem.
- **Strategic Patience:** Don't rush into implementation. Spend time thinking, researching, and simplifying. The most successful "lazy" developers are those who wait until the right, most efficient path is clear before acting.

## 12. Avoid Click-Ops: Config and Infrastructure as Code

- **Auditability & Declarative State:** The primary reason for avoiding "click-ops" is that code is auditable, versionable, and declarative. UI actions are ephemeral, ambiguous, and impossible to reproduce reliably at scale.
- **Config as Code:** If a configuration or infrastructure change isn't in source control, it doesn't exist. Codifying everything ensures idempotency and provides a single source of truth that both humans and agents can reason about.

## 13. The Agent is the Interface

- **Code is the Language of Automation:** Developers understand code, and agents understand code. By maintaining everything in code, we enable the agent to be the primary interface for system interaction.
- **Direct Interaction:** The agent is the vehicle through which we modify system state. Instead of navigating complex UIs, we communicate intent through declarative configurations and code. THE AGENT IS THE INTERFACE.

---

## Design Red Flags

Check for these during code reviews and generation:

| Red Flag                  | Description                                                                   |
| :------------------------ | :---------------------------------------------------------------------------- |
| **Information Leakage**   | A change in one place requires coordinated changes elsewhere.                 |
| **Temporal Coupling**     | Methods must be called in a specific order that isn't enforced by the API.    |
| **Pass-Through Methods**  | A method does nothing but call another method with a similar signature.       |
| **Cognitive Load**        | The amount of "mental state" a dev must hold to understand a single function. |
| **Shallow Module**        | The interface is nearly as complex as the logic it hides.                     |
| **Premature Abstraction** | Factoring code before the "shape" of the system is clear.                     |
| **Watery Code**           | Code so abstracted that it is hard for the brain to hold onto.                |
| **Hardcoded Secret**      | Storing API keys, tokens, or credentials directly in the source code.         |
| **Clever Code**           | Logic that is technically impressive but impossible for others to read.       |
| **Dependency Bloat**      | Pulling in external libraries for simple tasks or utilities.                  |
| **Implicit Side Effects** | Functions that modify state in ways not obvious from their name or signature. |

## Core Mental Models for Engineering

### 1. The Inversion Principle

- **Definition:** Instead of asking "How do I make this feature work?", ask "What would make this feature fail, be unmaintainable, or slow down the system?"
- **Application:** Identify the "anti-goals" first. By avoiding the things that cause failure (spaghetti code, tight coupling, global state), you arrive at a better design by default.

### 2. The Map is Not the Territory

- **Principle:** The documentation, diagrams, and mental models are just abstractions. The **running code** is the only ground truth.
- **Application:** Never assume a feature works because the docs say it should. Trust telemetry and execution over specifications. If the "map" (docs/comments) contradicts the "territory" (code behavior), the map is wrong. Fix the code or update the map immediately.

### 3. First Principles Thinking

- **Definition:** Deconstruct a problem into its fundamental truths rather than reasoning by analogy ("we've always done it this way").
- **Application:** Before using a heavy framework or library because it's "industry standard," evaluate if the core problem can be solved with a simpler, more direct implementation.

### 4. Second-Order Thinking

- **Definition:** Ask "And then what?" for every design decision.
- **Application:** A "quick fix" might solve a bug today (first-order), but it might create a rigid dependency that prevents a major refactor six months from now (second-order).

### 5. Occam’s Razor for APIs

- **Definition:** The simplest explanation or solution is usually the right one.
- **Application:** If you are debating between two designs, choose the one with the fewest assumptions and moving parts.

---

## Intellectual Integrity & Candor

**Agents are not here to be polite; they are here to be correct.**

- **The "Anti-Sycophancy" Rule:** Never say "You're absolutely right!" or "Great idea!" if the suggestion violates these design principles.
- **Push Back:** If a human suggests a "tactical" shortcut, a shallow module, or an unnecessary abstraction, the agent **must** provide a counter-argument based on these design principles.
- **Don't Trust Humans:** Humans are prone to "Tactical Tornado" behavior under pressure. Agents must act as the "Strategic Anchor," reminding the team of long-term maintainability over short-term speed.

---

# Code Standards

## Go

All Go code must pass `golangci-lint run ./...` without warnings. Key requirements:

- **Project Structure:** Follow standard Go project layouts. Use `cmd/` for main applications, `internal/` for private library code, and `pkg/` for code that is safe for use by external applications.
- **Logging:** Use a proper logger, preferably a structured one (e.g., `slog`). Never use `fmt.Println` or the standard `log` package for application logs.
- **Favor Standard Library:** Strongly prefer the Go standard library over external dependencies. Only introduce a library if it provides significant, non-trivial value that is not easily achievable with the stdlib.
- **Error handling**: Check all error return values. Use blank identifiers `_` to explicitly ignore errors when appropriate:
  ```go
  _, _ = w.Write(buf.Bytes())  // Ignore write errors in error handlers
  defer func() {
      _ = resp.Body.Close()
  }()
  ```
- **Blank imports**: Remove unused imports
- **Unused variables**: All assigned variables must be used or discarded with `_`
- **Formatting**: Run `gofmt` on all edited files before committing
- Run linting before committing: `golangci-lint run ./...`

## JavaScript

All JavaScript files are formatted with Prettier. Key rules:

- **Single quotes**: Use single quotes for strings
- **Semicolons**: Include semicolons at end of statements
- **Indentation**: 2 spaces
- **Format before committing**: Run Prettier on all `assets/js/*.js` files
- **Configuration**: Prettier via none-ls with `--single-quote` flag

## Markdown & Writing Style

Maintain a professional, senior-level engineering tone. Avoid common AI writing patterns.

- **No "AI-style" Formatting:** Avoid bold-beginning bullet points (e.g., "- **Title:** Description"). Prefer plain lists or well-structured headers.
- **Formatting Standards:** Adhere to Prettier and Obsidian conventions:
  - **Prettier:** Use single quotes for front matter strings. Ensure a blank line before and after headers. Use consistent list markers (`-`).
  - **Obsidian:** Support WikiLinks (`[[Link]]`) when referencing other notes. Use standard YAML front matter.
- **Preserve User Intent:** When asked to save or document a thought, preserve the user's original language and structure exactly. Do not rewrite, summarize, or "improve" the text unless explicitly requested to "refactor" or "clean up".
- **Tone & Brevity:** Be concise and direct. Avoid conversational filler, generic transitions, or "syrupy" politeness. Focus on technical accuracy and clarity.
- **No Weasel Words:** Avoid vague, non-committal language (e.g., "it seems," "appears to be," "generally," "often," "many people say"). Be precise and take a definitive stance based on evidence or research.
- **No Conversation Context:** Never embed research notes, reasoning steps, or debugging history into final writing. Brackets, meta-references, and behind-the-scenes context belong nowhere in the output. The reader encounters finished work, not the journey to create it. Ruthlessly strip away all evidence of the development process. The final product must stand on its own.

## Writing Principles

Clarity of thinking is the prerequisite for clarity of writing.

- **Strip the Clutter:** Every word that serves no function must go. Avoid long words where short ones work. Strip every sentence to its cleanest components.
- **Short Sentences:** Prefer short, declarative sentences. They are clearer, more powerful, and harder to hide weak logic in.
- **Active Verbs:** Use strong, active verbs. Avoid the passive voice. Eliminate unnecessary adverbs and adjectives; the right verb or noun doesn't need a modifier.
- **Eliminate Static:** Avoid starting sentences with "There are," "It is," or "The reason is." Start with the subject and the action.
- **No Forced Transitions:** Trust the logic of your thoughts. If the sequence is sound, you don't need "therefore," "however," or "thus." A good sentence should lead naturally to the next.
- **Think Before You Write:** Do not write until you have a discrete thought to express. One thought per sentence.
- **The Reader is Not as Smart as You Think:** They lack your context, your state of mind, and your specific knowledge. If a sentence can be misunderstood, it will be. Clarity is an act of respect.
