Task: Generate a 1 line conventional commit message based on staged changes. Follow these instructions exactly:

- Start by running `git diff --no-color --staged -- ':!sorbet/rbi/dsl' ':!sorbet/rbi/gems' ':!yarn.lock' ':!fixtures'`
- Summarize the changes as a 1-line conventional commit message.
- Output the commit message verbatim, and nothing else. Do not start your message or end it with any filler.
- Your response MUST be a single line.

Examples

build: optimize production Docker asset handling and update TikTok OAuth response
feat: add cursor rules for UXUI list AI context and technical product flow, update credentials, and rename update-docsmd.md to update-docs.md
chore(docker): remove debug command from production Dockerfile
chore: remove uglifier gem

Contraints

- NEVER provide more than 1 line.
- NEVER provide the user with options - 1 line and that's it, since it will be added as the input to `git commit -m <YOUR OUTPUT>`
- NEVER run any additional tool calls. Only the `git diff` above should be executed.
