# Notes vault

This is an Obsidian vault synced via iCloud. Some notes are published via Obsidian Publish.

## Privacy

- Notes mentioning my employer or specific work projects must have `publish: false` in their frontmatter.
- Journal entries are private by default and should always have `publish: false`.
- Be careful with notes containing API keys or credentials -- flag these to me.

## Vault structure

- `📥 Inbox.md` -- raw links and sources waiting to be processed
- `Clippings/` -- web clippings saved from the browser (have frontmatter with source, author, etc.)
- `Journal/` -- daily journal entries
- `Attachments/` -- images and files
- Everything else in the root is a topic/evergreen note

## Note conventions

- Use `[[wikilinks]]` to connect related concepts
- End notes with a line of related `[[concept]]` links when relevant
- Voice: direct, opinionated, concise. Summarize ideas in your own words, don't just quote
- No rigid template -- some notes are quick link dumps, some are full essays
- Frontmatter is optional. Use it for `publish`, `category`, `source`, `author` when relevant

## Ingest workflow

The `/ingest` command processes items from `📥 Inbox.md`. For each URL or source:

1. Fetch and read the source content
2. Decide: does this extend an existing topic note, or warrant a new one?
   - If an existing note covers this topic, update it with the new information and add the source link
   - If it's a new concept, create a new note in the vault root
3. Add `[[wikilinks]]` to connect it to other notes in the vault
4. Remove the processed item from `📥 Inbox.md`

When creating or updating notes:
- Summarize in my voice -- what's interesting, what's the insight, why does it matter
- Don't just regurgitate the source. Extract the idea and connect it to what I already know
- Include source URLs inline or at the bottom so I can find the original
- Check for existing notes that should link to/from the new content
