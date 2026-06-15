# CLAUDE.md

Read `docs/agents/FLUTTER_UI_AGENT.md` for your role and rules.

Key points:
- You build Flutter widgets for the Mitumba design system
- Match web components from `@mitumba/ui` (see `../mitumba-ui` or GitHub)
- Atomic commits, never push to main, PRs only
- Every merge = release to pub.dev
- Use Conventional Commits format
- Run `flutter analyze` + `flutter test` before any PR
