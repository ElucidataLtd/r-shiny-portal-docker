Jira ticket:  

_What has changed? Copy from change log or write it from scratch._

# Check list

## Before asking for a review - developer

- [ ] Target branch is `master`
- [ ] Add a section to the changelog with the Release number. (If this is only one ticket of a multi-ticket release then just add your changes to the `[Unreleased]`] section in CHANGELOG.md. Use a JIRA Subtask if possible.
- [ ] I reviewed the "Files changed" tab and annotated anything unexpected.

## During review - reviewer

- [ ] All of the above are checked and true. **Review ALL items.** If not, return the PR back to the author.

## After review - developer or reviewer

- [ ] **Squash and merge** (not Create a merge) type of merge is selected.

## After merge - developer

- [ ] A Release on Github has been created, matching the release version in CHANGELOG.md. (If this is only one ticket of a multi-ticket release then don't do this.
- [ ] Jira ticket is updated.
