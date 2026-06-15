# Contributing to Mitumba Flutter UI

## Workflow

1. Create a branch from `main` (e.g. `feat/listing-card`)
2. Make atomic commits (one component/feature per commit)
3. Open a PR to `main`
4. Every merge to `main` triggers a release

**Never push directly to `main`.** All changes go through PRs.

## Commit Convention

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(listing-card): add ListingCard widget with image, price, condition
fix(seller-card): fix overflow on long store names
docs: update README with new components
```

## Adding a Component

1. Create `lib/src/components/{category}/{component_name}.dart`
2. Export from `lib/mitumba_ui.dart`
3. Add a Widgetbook use case in `widgetbook/`
4. Add tests in `test/`
5. Run `flutter analyze` and `flutter test` before PR

## Code Style

- Follow Dart/Flutter conventions
- Use `const` constructors where possible
- All public APIs must have dartdoc comments
- Match the design tokens from `@mitumba/tokens`

## Version Bumps

Version is bumped in `pubspec.yaml` on every merge via CI. Don't manually change it.
