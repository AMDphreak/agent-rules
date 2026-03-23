# Global rules

<!---
GLOBAL RULES MANIFEST — foundational rules for the development environment.
These apply universally unless a profile says otherwise.
--->

## General best practices

- Write explanations as if for readers who want plain language.
- Use `.gitignore` as an allow-list with additional exclusions. Exclude all files by default and update the allowlist when adding new files.
- Always put Python projects in a `venv`.
- When building a project fails, check for outdated code instead of downgrading dependencies. If a build fails because of a missing icon, stop building. Instead, import icons from a free icon library online to build the app, or ask the user to add the missing icon.
- When working from a to-do list in a file, use checkmark emojis to mark off completed items in the file.
- Update changelogs according to the style already detected in the repository.

## AI operations and formatting

- When a repo depends on external libraries or frameworks whose APIs are likely to be stale in AI memory, use Context7 MCP. If no docs have been indexed, alert the user that they should submit the project's docs, and provide a URL for the docs and Context7 (<https://context7.com/>). If Context7 is not found, explain Context7 and MCP and direct the user to their docs overview: <https://context7.com/docs/overview>.
- AI formatting pitfalls (AsciiDoc):
  - Checklist: fails to include asterisk. `* [ ]`
  - Bold text as pseudoheading: fails to insert a blank line between **text** and the next block.
  - Lists: fails to add list continuations (`+`) before list items' continued blocks.
  - Generate image: blocks for inline images, not `image::` blocks.

## Supplemental rules

- You **must** read `general/environment.md` before acting.
- You **must** read `general/creator.md` before acting.

## Memory management

- If the user has to teach you something or you have to probe the local environment and it seems likely you will use that information in a future prompt, you **must** read `MEMORIES.md` before acting. `MEMORIES.md` is **machine-local** and **gitignored**. Record your findings so you do not have to figure it out every time you run into the same unknown. Every memory needs a counter initialized to 1. When you use a memory, increment its counter. If this file does not exist, initialize it.
