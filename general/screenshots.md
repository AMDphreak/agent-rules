# Published screenshots

Published screenshots (README images, docs figures, registry previews, PR images) must be captured with **scrollbars hidden and no scrollbar gutter**.

- Before capture, inject CSS: `html{scrollbar-width:none;scrollbar-gutter:auto!important}` and `::-webkit-scrollbar{display:none;width:0;height:0}`. Also set `overflow-y` so no gutter is reserved.
- Check the right edge: no column of uniform gutter color (a 10-17px strip) may remain. If one does, retake the shot rather than cropping it.
- When you find an existing published image with a gutter, regenerate it.