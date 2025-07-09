# Workflow 2: Create Pull Request

**Trigger:** Human says "create a PR for issue #42" or "create a PR"
**Prerequisites:** Development work is complete, code is ready for review, commits already exist

**🚨 CRITICAL: This workflow assumes your feature/fix is already implemented and tested with existing commits. If you need to start development, use Workflow 1(/docs/AGENTS_RESOLVE_ISSUE.md) instead.**

**🚨 Before starting, read CONTRIBUTING.md for the complete PR creation workflow and README.md for the project overview.**

## Step 1: Identify Issue Number

- If not provided, extract from the branch name (e.g., `45-feature-name` → issue #45)
- Verify the issue exists: `gh issue view <issue-number>`

**📖 Refer to CONTRIBUTING.md for branch naming conventions.**

### Step 2: Verify Readiness

- [ ] All tests pass
- [ ] Build succeeds
- [ ] Code follows standards (TOC at the top of files, functions >10 lines documented)
- [ ] At least one commit exists (required for PR creation)

**📖 MANDATORY: Check CONTRIBUTING.md for the complete pre-submission checklist and README.md for build requirements.**

### Step 3: Create PR for Review

**📖 CRITICAL: Follow CONTRIBUTING.md Step 3 for exact process requirements.**

**3a. Clean Up Git History:**

```bash
./scripts/squash-commits.sh
```

**3b. Create PR:**

**Prepare PR body:**

- Copy the template from `.github/PULL_REQUEST_TEMPLATE.md`
- Create `.PR_BODY.md` in the project root using your code editor
- Fill out all sections completely

**Create the PR:**

```bash
# Get the exact issue title for consistency
./scripts/get-issue-title.sh <issue-number>

# Create PR, add --push to eliminates the interactive prompt.
gh pr create \
  --title "<issue-title> #<issue-number>" \
  --body-file .PR_BODY.md \
  --base main
  --push

# Clean up the temporary file
rm .PR_BODY.md
```

**3c. Verification Checklist:**

- [ ] Clean commit history with proper format
- [ ] PR template fully completed
- [ ] Correct title format: `<issue-title> #<issue-number>`

### Step 4: Clean Up

Your work is done.

---
