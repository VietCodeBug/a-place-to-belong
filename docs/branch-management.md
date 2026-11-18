# Branch layout — 2026-11-18

Repository: [VietCodeBug/a-place-to-belong](https://github.com/VietCodeBug/a-place-to-belong), ID1459537532. The owner completed the repository rename; origin and active document URLs use the new slug.

Exactly three remote branch heads remain:

| Branch | Purpose |
|---|---|
| main | Default baseline; README branding updated separately, without merging gameplay PR10 |
| feature/map01-lighting-presets | Current development / PR10; A Place to Belong application and menu branding |
| story/forest-post-cafe-narrative | Creator narrative documents, unchanged |

Seven removed heads (3D_model, feature/v10-map01-visual-overhaul, preview/ver-09 through ver-13) were first pushed and verified as same-name tags at identical original commits. See [exact archive receipt](branch-archive-2026-11-18.json). Earlier 18 tags remain unchanged. Source, screenshots and history are retained. Old preview READMEs still describe their historical version; changing those would falsify the snapshot.

Future screenshots use versioned tags rather than leaving new preview branch heads. Continue development on the existing development branch; no automatic PR merges. Do not rename the story branch just to match the new brand, and do not edit docs/story.

To inspect an archived snapshot without creating a branch:

```sh
git fetch origin --tags
git show refs/tags/preview/ver-13-circular-postal-ui:README.md
```

GitHub About description is separate from repository name and README. Updating it through the integration returned HTTP403. The owner can edit About using the gear icon and paste the new tagline; no name/metadata change is falsely claimed here.
