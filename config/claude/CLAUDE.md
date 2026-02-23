- Prefer guard style over nested conditionals
- No get/set accessor prefixes (`foo`, not `getFoo`/`setFoo`)

## Comments

- Use `// --` as a section divider when nessecary
- Don't write comments explaining what the code does, only include comments saying _why_ the code is there.

## Git

- When writing commit messages, try to include as much context around _why_ this change was made.
- Use the imperative mood in commit message titles.
- Always include a "## Test plan" section in commit messages. The test plan is intended to give the reader of the commit confidence that it does what it says it does. Automated tests are best but manual test steps are fine too. It's OK to say that the test plan is "YOLO" if there isn't a clear test plan.
