Process the next unprocessed item(s) from `📥 Inbox.md`.

Use the Obsidian CLI (`obsidian` command) to read and write notes in the vault. Use WebFetch or the defuddle skill to read URLs.

For each item (URL, link, or note):

1. Read the source. For URLs, fetch the page and extract the content.
2. Search the vault for existing notes on the same topic or related concepts:
   - `obsidian search query="<topic>"` to find related notes
   - `obsidian read file="<name>"` to read a candidate note
   - `obsidian backlinks file="<name>"` to understand connections
3. Either update an existing note or create a new one:
   - To update: `obsidian append file="<name>" content="<text>"`
   - To create: `obsidian create path="<name>.md" content="<text>"`
   - Summarize the key insight in my voice — direct, opinionated, concise
   - Add source URL so I can find the original
   - Add `[[wikilinks]]` connecting to existing vault notes
   - Add related concept links at the bottom if relevant
4. Remove the processed item from `📥 Inbox.md`.

If running interactively, process items one at a time — show what you did and ask if I want to continue with the next one.

If running headlessly (i.e. $ARGUMENTS contains "all"), process all items without stopping.

For bare URLs: fetch the content, figure out what it's about, and file it like anything else. Everything has a topic — find it.

## Media

Notes are easier to scan when they have visuals. When ingesting:

- If the source has a key diagram, screenshot, or photo — download it to `Attachments/` and embed with `![[Attachments/filename.ext]]`
- For YouTube URLs, embed directly with `![title](https://www.youtube.com/watch?v=ID)`
- For other videos, embed the URL so Obsidian can preview it
- Prefer images that explain the concept (diagrams, architecture drawings, UI screenshots) over decorative ones
