# Branch layout after cleanup — 2026-11-17

The user requested fewer branches. Keep these four remote heads:

| Branch | Purpose |
| --- | --- |
| main | Published/default history; unchanged by cleanup |
| 3D_model | Existing user branch; unchanged |
| feature/map01-lighting-presets | Current complete prototype, including all earlier feature work |
| preview/ver-09-grass-sky-weather | Latest image and motion review |

All nine older feature branches are ancestors of the current code. Archive those and eight older preview branches as **tags with exactly the same names and commit IDs**, verify the tags on GitHub, then remove the redundant branch heads. Existing `/tree/preview/ver-XX-...` links still resolve to the same snapshots via tags. Nothing is merged into main or removed from Git history.

`branch-archive-2026-11-17.json` records the exact source commits and archive tags. Closed PRs #1–9 remain historical reviews; PR #10 targets main and represents the complete prototype for review. Closing old PRs does not mean their art was approved or their changes merged.

Use the existing current code branch/PR for follow-up edits unless the user requests isolation. Keep each new image session versioned; retain the latest preview as a branch and archive older preview heads as same-name tags before removing them. Choose the next version using **both remote branches and tags**. Preserve all snapshot contents and URLs.

Restore an archived branch if needed:

```sh
git fetch origin tag preview/ver-07-samatha-player
git switch -c restored-samatha refs/tags/preview/ver-07-samatha-player
```

No gameplay or asset files changed during this cleanup. Previous validation remains recorded in the visual reports; cleanup does not grant permission to merge or approve art.

V09 follow-up: ver-08 is archived to the identical `preview/ver-08-lighting-presets` tag before its branch head is removed. Source code continues on the same feature branch and PR #10.
