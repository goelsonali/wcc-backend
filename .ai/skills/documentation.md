# Skill: documentation

Generate or update documentation for changed or specified code — Javadoc, README sections, or inline comments — following project conventions.

## When to apply

Run this workflow when the user asks to document code, add Javadoc, update the README, or `/documentation`.

## Step 1 — Identify scope

Determine what needs documenting from the user's request:

- If the user names specific files or classes — document those.
- If the user says "document my changes" — run `git diff HEAD` and document changed files.
- If the user says "document everything" — ask which package or layer to focus on first.

## Step 2 — Read the target code

Read each target file in full before writing any documentation. Understand:

- Purpose of the class / method / field
- Parameters, return types, and checked exceptions
- Any non-obvious logic that warrants an inline comment

Do NOT guess at intent from the name alone — read the implementation.

## Step 3 — Check existing documentation

Before adding anything, look for existing Javadoc or comments in each file.

- If a Javadoc block already exists — update it, do not duplicate it.
- If inline comments already explain the logic clearly — leave them alone.
- Do not add comments that merely restate what the code already says.

## Step 4 — Write documentation

Apply the following rules per artifact type:

### Javadoc (Java classes, methods, fields)

- Every `public` and `protected` class, method, and constructor must have a Javadoc block.
- First sentence: one-line summary ending with a period.
- Use `@param` for each parameter (skip trivial self-evident ones only if the team convention allows).
- Use `@return` unless the return type is `void`.
- Use `@throws` for each declared checked exception, and for unchecked exceptions that callers must handle.
- Do not use `@author` or `@version` tags.
- Keep descriptions concise and precise — avoid padding.

**Example:**
```java
/**
 * Registers a new mentee application for the given mentorship cycle.
 *
 * @param request the registration request containing mentee details and mentor preferences
 * @param cycle   the active mentorship cycle to register against
 * @return the saved {@link MenteeRegistration} with its generated ID
 * @throws MentorshipCycleClosedException if the cycle is not open for registration
 */
```

### Inline comments

- Use sparingly — only for logic that is not self-evident from the code.
- Explain *why*, not *what*.
- Use block comments for multi-line explanations; single-line `//` for brief notes.
- Do not comment out dead code — delete it.

### README / markdown sections

- Match the heading style and tone of the existing document.
- Use imperative mood for instructions ("Run the command", not "You should run").
- Include a code block for any commands or configuration snippets.
- Keep sections short; link to more detail rather than expanding inline.

## Step 5 — Apply changes

Edit each file using the Edit tool. Make only documentation changes — do not refactor, rename, or alter logic.

After editing, briefly list the files changed and what was added or updated.

## Rules

- Never alter logic or rename identifiers — documentation only
- Always read the code before writing docs
- Do not duplicate existing documentation — update it
- Prefer concise and precise over comprehensive and verbose
- Follow project Javadoc conventions from CLAUDE.md
