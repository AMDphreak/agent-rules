# Repository organization schema

Clone repositories into the following path pattern (set `CODE_ROOT` in your `profiles/*.md` file):

- `$CODE_ROOT/<host>/<owner>/<repo>` if the project is a repository you own or is owned by an organization you are a member of (not a fork).
  Example: `$CODE_ROOT/github.com/<your-username>/my-project-name`

- `$CODE_ROOT/<host>/<owner>/.forks/<repo>` if the project is a fork in your personal account or an organization account you are a member of.
  Example: `$CODE_ROOT/github.com/<your-username>/.forks/obs-studio`

- `$CODE_ROOT/<host>/<org>/<repo>` if the project is owned by an organization you are a member of (same as rule 1).
  Example: `$CODE_ROOT/github.com/dev-centr/dev-centr`

- `$CODE_ROOT/<host>/.clones/<owner>/<repo>` if the project is a pure clone (not forked, not owned by you or your organizations).
  Example: `$CODE_ROOT/github.com/.clones/obsproject/obs-studio`

Where:

- **`CODE_ROOT`** is the base code directory (define per machine in `profiles/`)
- **`<host>`** is the Git host (e.g. `github.com`, `gitlab.com`)
- **`<owner>`** is the organization or user name that owns the repository
- **`<repo>`** is the repository name
- **`<org>`** is the organization name that owns the repository (same as owner for organizations)

### Org membership checks

GitHub:

- List all orgs you are a member of with `gh api user/memberships/orgs --jq '.[].organization.login'`
- Check for membership in an org with `gh api orgs/<org>/memberships/<username>`

GitLab:

- List all groups you are a member of with `glab api "groups?min_access_level=10" --jq '.[].full_path'`
- Check for membership in a group with `glab api "groups/<group_id>/members/all" --jq '.[] | select(.username=="<your_username>")'`

---
*This file serves as a reminder for AI agents to maintain consistency within the workspace.*
