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

These notes aspire to be "evergreen" in the Andy Matuschak sense -- they should
evolve and accumulate over time, not just sit there.

### Titles are claims, not topics

Prefer titles that make an assertion: "Middleware is a dangerous pattern", not
"Middleware". A good title is an API -- you should be able to reference it in
another note and the reader immediately gets the point. Topic-label notes
("Erlang", "BEAM VM") are fine as reference pages, but the interesting notes
make a claim.

### One concept per note

Notes should be atomic -- focused on a single idea. If a note covers two
separable ideas, split it. This makes each note more linkable and reusable.
You should be able to write a note in under 30 minutes.

### Organize by concept, not by source

Don't file notes by book, author, or project. File them by the idea. When two
different sources discuss the same concept, they should enrich the same note.
This creates synthesis pressure -- you have to reconcile conflicting ideas
rather than just collecting them.

### Link densely

Every note should link to related concepts. This isn't just navigation -- the
act of finding links forces you to re-read old notes and discover unexpected
connections. Link to stubs that don't exist yet; they'll get written later.

### Voice and formatting

- Direct, opinionated, concise. Summarize ideas in your own words, don't just quote
- Use `[[wikilinks]]` to connect related concepts
- End notes with a line of related `[[concept]]` links when relevant
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
- Prefer claim-titles over topic-titles when the source makes a clear point
- If a source touches multiple ideas, create/update multiple atomic notes
- Always search for existing notes first -- enrich, don't duplicate
