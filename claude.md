# Claude Code Instructions for The Shy Dock

## Project Overview
The Shy Dock is a macOS menu bar utility that intelligently manages the Dock based on external monitor connections. Built with SwiftUI + AppKit.

## Workflow: Linear + GitHub Integration

### When Starting Work on a Linear Issue

1. **Fetch the Linear Issue**
   - Use the Linear MCP server to get issue details: `mcp__linear-server__get_issue`
   - Extract the issue identifier (e.g., `VOV-12`), title, and description

2. **Create a Feature Branch**
   - Branch naming convention: `<username>/vov-<issue-number>-<brief-description>`
   - Example: `vovawed/vov-12-rename-folders-and-files`
   - Always branch from `master` (the main branch)
   - Command: `git checkout -b <username>/vov-<issue-number>-<brief-description> master`

3. **Update Linear Issue Status**
   - When starting work, update the Linear issue status to "In Progress"
   - Use: `mcp__linear-server__update_issue`

### Making Commits

1. **Commit Message Format**
   - First line: Clear, concise summary of changes
   - Body: Detailed explanation of what changed and why
   - Reference the Linear issue: `Addresses VOV-<number>` or `Fixes VOV-<number>`
   - Always include the Claude Code footer:
     ```
     🤖 Generated with [Claude Code](https://claude.com/claude-code)

     Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
     ```

2. **Example Commit Message**
   ```
   Rename app to 'The Shy Dock' everywhere

   This commit addresses VOV-12 with the following improvements:

   1. Renamed all folder references from DockAway to The Shy Dock
   2. Updated Xcode project configuration
   3. Updated app bundle identifiers

   🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
   ```

### Creating Pull Requests

1. **Before Creating PR**
   - Ensure all changes are committed
   - Run tests if applicable: `xcodebuild test`
   - Build the project: `xcodebuild -scheme "The Shy Dock" build`
   - Push the branch: `git push -u origin <branch-name>`

2. **PR Title Format**
   - Use the Linear issue title or a clear summary
   - Example: "Rename folders and files to The Shy Dock"

3. **PR Description Format**
   ```markdown
   ## Summary
   - Brief bullet point of what changed
   - Why the change was needed
   - Any important implementation details

   ## Linear Issue
   Fixes [VOV-<number>](https://linear.app/link-to-issue)

   ## Test Plan
   - [ ] Built successfully in Xcode
   - [ ] Tested on macOS 14.5+
   - [ ] Verified menu bar functionality
   - [ ] Checked settings window
   - [ ] Tested with/without external displays

   🤖 Generated with [Claude Code](https://claude.com/claude-code)
   ```

4. **Create PR Command**
   ```bash
   gh pr create --title "Title here" --body "$(cat <<'EOF'
   [PR description here]
   EOF
   )"
   ```

5. **After PR Creation**
   - Add a comment to the Linear issue with the PR link
   - Use: `mcp__linear-server__create_comment`

### Linear Issue Workflow

1. **Available MCP Server Tools**
   - `mcp__linear-server__get_issue` - Get issue details
   - `mcp__linear-server__update_issue` - Update issue status, assignee, etc.
   - `mcp__linear-server__create_comment` - Add comments to issues
   - `mcp__linear-server__list_issue_statuses` - Get available statuses

2. **Typical Issue Flow**
   - Todo → In Progress (when starting work)
   - In Progress → In Review (when PR is created)
   - In Review → Done (when PR is merged)

### Project-Specific Guidelines

1. **Code Style**
   - Swift: Follow SwiftUI and AppKit best practices
   - Use descriptive variable names
   - Add comments for complex logic
   - Keep functions focused and small

2. **Testing**
   - Always build the project before pushing
   - Test on macOS 14.5+ if possible
   - Verify menu bar interactions
   - Check external display detection logic

3. **Documentation**
   - Update README.md if adding new features
   - Document any new settings or configuration options
   - Keep the feature list current

## Quick Reference

### Branch from master
```bash
git checkout -b <username>/vov-<issue-number>-<description> master
```

### Commit with Linear reference
```bash
git commit -m "$(cat <<'EOF'
Title here

Addresses VOV-<number>

Details...

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF
)"
```

### Create PR
```bash
gh pr create --title "PR Title" --body "$(cat <<'EOF'
## Summary
- Changes here

Fixes VOV-<number>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

## Important Notes

- Always reference Linear issues in commits and PRs
- Use the Linear MCP server to keep issues updated
- Build and test before creating PRs
- Keep the main branch (`master`) stable
- Use descriptive branch names following the convention
