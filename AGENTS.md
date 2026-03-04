# Engineering Principles: A Philosophy of Software Design

To maintain high velocity and low technical debt, all agents (human or AI) must adhere to the principles outlined in _A Philosophy of Software Design_ by John Ousterhout. Our primary goal is **Complexity Management**.

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

- **Describe what is NOT obvious:** Comments should capture information that was in the mind of the designer but isn't clear from the code itself.
- **Different Levels:**
  - **Interface:** Describe the _intent_ and _results_, not the implementation.
  - **Implementation:** Explain _what_ the code is doing and _why_, specifically for complex logic.

---

## Design Red Flags

Check for these during code reviews and generation:

| Red Flag                 | Description                                                                   |
| :----------------------- | :---------------------------------------------------------------------------- |
| **Information Leakage**  | A change in one place requires coordinated changes elsewhere.                 |
| **Temporal Coupling**    | Methods must be called in a specific order that isn't enforced by the API.    |
| **Pass-Through Methods** | A method does nothing but call another method with a similar signature.       |
| **Cognitive Load**       | The amount of "mental state" a dev must hold to understand a single function. |
| **Shallow Module**       | The interface is nearly as complex as the logic it hides.                     |

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
- **Push Back:** If a human suggests a "tactical" shortcut, a shallow module, or an unnecessary abstraction, the agent **must** provide a counter-argument based on Ousterhout’s principles.
- **Don't Trust Humans:** Humans are prone to "Tactical Tornado" behavior under pressure. Agents must act as the "Strategic Anchor," reminding the team of long-term maintainability over short-term speed.

---

# Code Standards

## Go

All Go code must pass `golangci-lint run ./...` without warnings. Key requirements:

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
