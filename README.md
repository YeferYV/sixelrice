<div align="center">
    <img src="screenshot.png" alt="screenshot">
    <p>
        preview/play/open images/videos/pdf/text inside the terminal using
        <a href="https://github.com/gokcehan/lf">lf</a>/
        <a href="https://github.com/mpv-player/mpv">mpv-sixel</a>/
        <a href="https://github.com/neovim/neovim">neovim</a>
        <br>
        (neovim integrates text objects from A-Z and is based on <a href="https://github.com/lazyvim/lazyvim">lazyvim</a>)
    </p>

---

**[<kbd> <br> Install <br> </kbd>][Install]** 
**[<kbd> <br> Wiki <br> </kbd>][Wiki]** 
**[<kbd> <br> Dependencies <br> </kbd>][Dependencies]**

[Install]: #installation
[Wiki]: https://github.com/YeferYV/sixelrice/wiki
[Dependencies]: https://github.com/YeferYV/sixelrice/wiki/dependencies

</div>

---

<details open><summary>Table of Contents</summary>

1. Neovim TextObjects/Motions
   - [Neovim text object that starts with a/i](#neovim-text-object-that-starts-with-ai)
   - [Neovim text object that starts with g](#neovim-text-object-that-starts-with-g)
   - [Neovim Motions and Operators](#neovim-motions-and-operators)
2. Neovim GoTo
   - [Neovim Space TextObjects/Motions](#neovim-space-textobject-motions)
   - [Neovim Go to Previous / Next](#neovim-go-to-previous--next)
   - [Neovim Mini.bracketed](#neovim-minibracketed)
   - [Neovim native ctrl keys](#neovim-native-ctrl-keys)
3. Neovim keymaps.lua
   - [Neovim Editor keymaps](#neovim-editor-keymaps)
   - [Neovim Suggestion keymaps](#neovim-suggestion-keymaps)
4. [LF terminal file manager](#lf-terminal-file-manager)
5. [zsh keymaps](#zsh-keymaps)
6. Installation
   - [Dependencies Installation](#installation)
   - [Treesitter Installation](#treesitter-installation)
7. [Vim Cheatsheets](#vim-cheatsheets)
8. [Related projects](#related-projects)

</details>

---

## Neovim text object that starts with `a`/`i`

<details><summary></summary>

|         text-object keymap         | repeater key | finds and autojumps? | text-object name | description                                                                               | inner / outer                                                                 |
| :--------------------------------: | :----------: | :------------------: | :--------------- | :---------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------- |
|             `ia`, `aa`             |     `.`      |         yes          | \_argument       | whole argument/parameter of a function                                                    | outer includes comma                                                          |
|             `ib`, `ab`             |     `.`      |         yes          | \_braces         | find the nearest inside of `()` `[]` `{}`                                                 | outer includes braces                                                         |
|             `iB`, `aB`             |     `.`      |         yes          | \_brackets       | find the nearest inside of `{}` `:help iB`                                                | outer includes brackets                                                       |
|             `ie`, `ae`             |     `.`      |                      | line             | from start to end of line without beginning whitespaces (line wise)                       | outer includes begining whitespaces                                           |
|             `if`, `af`             |     `.`      |         yes          | \_function_call  | like `function args` but only when a function is called                                   | outer includes the function called                                            |
|             `ih`, `ah`             |     `.`      |         yes          | \_html_attribute | attribute in html/xml like `href="foobar.com"`                                            | inner is only the value inside the quotes trailing comma and space            |
|             `ii`, `ai`             |     `.`      |                      | indent_noblanks  | surrounding lines with same or higher indentation delimited by blanklines                 | outer includes line above                                                     |
|             `iI`, `aI`             |     `.`      |                      | indent           | surrounding lines with same or higher indentation                                         | outer includes line above and below                                           |
|             `ik`, `ak`             |     `.`      |         yes          | \_key            | key of key-value pair, or left side of a assignment                                       | outer includes spaces                                                         |
|             `il`, `al`             |     `.`      |         yes          | +last            | go to last mini.ai text-object (which start with `_`)                                     | requires `i`/`a` example `vilk`                                               |
|             `in`, `an`             |     `.`      |         yes          | +next            | go to Next mini.ai text-object (which start with `_`)                                     | requires `i`/`a` example `viNk`                                               |
|             `im`, `am`             |     `.`      |         yes          | \_number         | numbers, similar to `<C-a>`                                                               | inner: only pure digits, outer: number including minus sign and decimal point |
|             `io`, `ao`             |     `.`      |         yes          | \_whitespaces    | whitespace beetween characters                                                            | outer includes surroundings                                                   |
|             `ip`, `ap`             |     `.`      |                      | paragraph        | blanklines can also be treat as paragraphs when focused on a blankline                    | outer includes below lines                                                    |
|             `iq`, `aq`             |     `.`      |         yes          | \_quotes         | inside of `` ` ` `` or `' '` or `" "`                                                     | outer includes openning and closing quotes                                    |
|             `is`, `as`             |     `.`      |                      | sentence         | sentence delimited by dots of blanklines `:help sentence`                                 | outer includes spaces                                                         |
|             `it`, `at`             |     `.`      |         yes          | \_tag            | inside of a html/jsx tag                                                                  | outer includes openning and closing tags                                      |
|             `iu`, `au`             |     `.`      |                      | \_subword        | like `iw`, but treating `-`, `_`, and `.` as word delimiters _and_ only part of camelCase | outer includes trailing `_`,`-`, or space                                     |
|             `iv`, `av`             |     `.`      |         yes          | \_value          | value of key-value pair, or right side of a assignment                                    | outer includes trailing commas or semicolons or spaces                        |
|             `iw`, `aw`             |     `.`      |                      | word             | from cursor to end of word (delimited by punctuation or space)                            | outer includes whitespace ending                                              |
|             `iW`, `aW`             |     `.`      |                      | WORD             | from cursor to end of WORD (includes punctuation)                                         | outer includes whitespace ending                                              |
|             `ix`, `ax`             |     `.`      |         yes          | \_Hex            | hexadecimal number or color                                                               | outer includes hash `#`                                                       |
|             `iy`, `ay`             |     `.`      |                      | same_indent      | surrounding lines with only same indent (delimited by blankspaces or commented lines)     | outer includes blankspaces                                                    |
|             `i?`, `a?`             |     `.`      |         yes          | \_user_prompt    | will ask you for enter the delimiters of a text object (useful for dot repeteability)     | outer includes surroundings                                                   |
|       `i(`, `i)`, `a(`, `a)`       |     `.`      |         yes          | `(` or `)`       | inside `()`                                                                               | outer includes surroundings                                                   |
|       `i[`, `i]`, `a[`, `a]`       |     `.`      |         yes          | `[` or `]`       | inside `[]`                                                                               | outer includes surroundings                                                   |
|       `i{`, `i}`, `a{`, `a}`       |     `.`      |         yes          | `{` or `}`       | inside `{}`                                                                               | outer includes surroundings                                                   |
|       `i<`, `i>`, `a<`, `a>`       |     `.`      |         yes          | `<` or `>`       | inside `<>`                                                                               | outer includes surroundings                                                   |
|         `` i` ``, `` a` ``         |     `.`      |         yes          | apostrophe       | inside `` ` ` ``                                                                          | outer includes surroundings                                                   |
| `i<punctuation>`, `a<punctuation>` |     `.`      |         yes          | `<punctuation>`  | inside `<punctuation><punctuation>`                                                       | outer includes surroundings                                                   |

</details>

## Neovim text object that starts with `g`

<details><summary></summary>

| text-object keymap |  mode   | repeater key | text-object description                                       | normal mode                              | operating-pending mode | visual mode                  | examples in normal mode                                                          |
| :----------------: | :-----: | :----------: | :------------------------------------------------------------ | :--------------------------------------- | :--------------------- | :--------------------------- | :------------------------------------------------------------------------------- |
|    `g[` or `g]`    | `o`,`x` |              | +cursor to left/right around (only textobj with `_` prefix)   |                                          | followed by textobject | uses selected region         | `vg]u` will select until quotation                                               |
|        `g>`        | `o`,`x` |     `.`      | next find                                                     |                                          | will find and jump     | uses selection               | `cgf???` will replace last search with `???` forwardly                           |
|        `g<`        | `o`,`x` |     `.`      | prev find                                                     |                                          | will find and jump     | uses selection               | `cgF???` will replace last search with `???` backwardly                          |
|        `g.`        | `o`,`x` |              | jump to last change                                           |                                          | won't jump             | uses selection               | `vg.` will select from cursor position until last change                         |
|        `ga`        | `n`,`x` |              | align                                                         | followed by textobject/motion            |                        | uses selected region         | `vipga=` will align a paragraph by `=`                                           |
|        `gA`        | `n`,`x` |              | preview align (`escape` to cancel, `enter` to accept)         | followed by textobject/motion            |                        | uses selected region         | `vipgA=` will align a paraghaph by `=`                                           |
|        `gb`        | `n`,`x` |     `.`      | blackhole register                                            | followed by textobject/motion            |                        | deletes selection            | `vipgb` will delete a paragraph without copying                                  |
|        `gB`        | `n`,`x` |     `.`      | blackhole linewise                                            | textobject not required                  |                        | deletes line                 | `gB.` will delete two lines without saving it in the register                    |
|        `gc`        | `o`,`x` |     `.`      | comment (`vgc` in normal mode will select a block comment)    |                                          | won't jump             | uses selection               | `vipgc` will comment a paragraph                                                 |
|        `gC`        | `o`,`x` |     `.`      | block comment (supports selection `vgC`)                      |                                          | won't jump             | reselects                    | `vgC` will select current block of comment                                       |
|        `gd`        | `o`,`x` |     `.`      | diagnostic (requires LSP so only works inside neovim)         |                                          | will find and jump     | will find and jump           | `vgd` will select the error                                                      |
|        `ge`        | `o`,`x` |              | previous end of word                                          |                                          | uses cursor position   | uses selection               | `vge` will select from cursor position until previous end of word                |
|        `gE`        | `o`,`x` |              | previous end of WORD ('WORD' omits punctuation )              |                                          | uses cursor position   | uses selection               | `vge` will select from cursor position until previous end of WORD                |
|        `gg`        | `o`,`x` |     `.`      | first line                                                    |                                          | uses cursor position   | uses selection               | `vgg` will select until first line                                               |
|        `gH`        |   `x`   |     `.`      | git hunk                                                      |                                          | won't jump             | relesects                    | `vgh` will select modified code                                                  |
|        `gi`        | `n`,`x` |              | last position of cursor in insert mode                        | will find and jump                       |                        | uses selection               | `vgi` will select until last insertion                                           |
|        `gj`        | `o`,`x` |     `.`      | go down when wrapped                                          |                                          | uses cursor position   | uses selection               | `vgj` will select one line down                                                  |
|        `gk`        | `o`,`x` |     `.`      | go up when wrapped                                            |                                          | uses cursor position   | uses selection               | `vgj` will select one line up                                                    |
|        `gm`        | `n`,`x` |              | +multiply (duplicate text) operator                           |                                          | won't jump             | uses selection               | `vapgm` will duplicate paragraph without replacing clipboard                     |
|        `gn`        | `o`,`x` |     `.`      | +next textobj (only textobj with `_` prefix)                  |                                          | followed by textobject | uses selection               | `vgniu` will select from cursor position until next quotation                    |
|        `gp`        | `o`,`x` |     `.`      | +previous textobj (only textobj with `_` prefix)              |                                          | followed by textobject | uses selection               | `vgpiu` will select from cursor position until previous quotation                |
|        `gq`        | `n`,`x` |     `.`      | +format selection/comments 80chars (LSP overrides it)         | requires a textobject                    |                        | applies to selection         | `vipgq` will format a paragraph                                                  |
|        `gr`        | `n`,`x` |     `.`      | +replace (with register) operator                             | followed by textobject/motion            |                        | applies to selection         | `viwgr` will replace word with register (yanked text)                            |
|        `gs`        | `n`,`x` |     `.`      | +sort Operator                                                | followed by textobject/motion            |                        | uses selection               | `vipgs` will sort paragraph                                                      |
|        `gS`        | `n`,`x` |     `.`      | join/split lines inside braces                                | will toggle inside `{}`,`[]`,`()`        |                        | followed by operator         | `vipgS` will join selected lines in one line                                     |
|        `gt`        | `n`,`x` |     `.`      | +go to end of textobj                                         | followed by textobject                   |                        | selects form cursor position | `vgliu` will select until start of quotation                                     |
|        `gT`        | `n`,`x` |     `.`      | +go to start of textobj                                       | followed by textobject                   |                        | selects from cursor position | `vghiu` will select until end of quotation                                       |
|        `gu`        | `n`,`x` |     `.`      | +to lowercase                                                 | requires a textobject                    |                        | applies to selection         | `vipgu` will lowercase a paragraph                                               |
|        `gU`        | `n`,`x` |     `.`      | +to uppercase                                                 | requires a textobject                    |                        | applies to selection         | `vipgU` will uppercase a paragraph                                               |
|        `gv`        | `n`,`x` |              | last selected                                                 | will find and jump                       |                        | reselects                    | `vgv` will select last selection                                                 |
|        `gw`        | `n`,`x` |     `.`      | split/join comments/lines 80chars (preserves cursor position) | requires a textobject                    |                        | applies to selection         | `vipgw` will split/join a paragraph limited by 80 characters                     |
|        `gx`        | `n`,`x` |     `.`      | +exchange (text) Operator                                     | followed by textobject/motion            |                        | uses selection               | `viwgx` will exchange word with another `viwgY`                                  |
|        `gz`        | `n`,`x` |     `.`      | +surround (followed by a=add, d=delete, r=replace)            | followed by textobject/motion (only add) |                        | uses selection (only add)    | `viwgza"` will add `"` to word, `gzd"` will delete `"`, `gzr"'` will replace `"` |
|        `g+`        | `n`,`x` |     `.`      | increment number                                              | selects number under cursor              |                        | uses selected number         | `3g+` will increment by 3                                                        |
|        `g-`        | `n`,`x` |     `.`      | decrement number                                              | selects number under cursor              |                        | uses selected number         | `g-..` will decrement by 3                                                       |
|      `g<Up>`       | `n`,`x` |              | numbers ascending                                             | selects number under cursor              |                        | uses selected number         | `g<Up>` will increase selected numbers ascendingly                               |
|     `g<Down>`      | `n`,`x` |              | numbers descending                                            | selects number under cursor              |                        | uses selected number         | `g<Down>` will decrease selected numbers descendingly                            |
|        `=`         | `n`,`x` |     `.`      | autoindent                                                    | followed by text-object                  |                        | uses selection               | `==` autoindents line                                                            |
|        `>`         | `n`,`x` |     `.`      | indent right                                                  | followed by text-object                  |                        | uses selection               | `>>` indents to right a line                                                     |
|        `<`         | `n`,`x` |     `.`      | indent left                                                   | followed by text-object                  |                        | uses selection               | `<<` indents to left a line                                                      |
|        `$`         |   `o`   |     `.`      | end of line                                                   |                                          |                        |                              | `d$j.` deletes two end-of-lines                                                  |
|        `%`         |   `o`   |              | matching character: '()', '{}', '[]'                          | won't jump                               |                        | won't jump                   | `d%` deletes until bracket                                                       |
|        `0`         |   `o`   |     `.`      | start of line                                                 |                                          |                        |                              | `d0` deletes until column 0                                                      |
|        `^`         |   `o`   |     `.`      | start of line (non-blank)                                     |                                          |                        |                              | `d^` deletes until start of line (after whitespace)                              |
|        `(`         |   `o`   |     `.`      | previous sentence                                             |                                          |                        |                              | `d(.` deletes until start of sentence (two times)                                |
|        `)`         |   `o`   |     `.`      | next sentence                                                 |                                          |                        |                              | `d).` deletes until end of sentence (two times)                                  |
|        `{`         |   `o`   |     `.`      | previous empty line (before a paragraph)                      |                                          |                        |                              | `d{.` deletes until next empty line (two times)                                  |
|        `}`         |   `o`   |     `.`      | next empty line (after a paragraph)                           |                                          |                        |                              | `d}.` deletes until previous empty line (two times)                              |
|        `[[`        |   `o`   |     `.`      | previous section                                              |                                          |                        |                              | `d[[` deletes until start of section                                             |
|        `]]`        |   `o`   |     `.`      | next section                                                  |                                          |                        |                              | `d]]` deletes until end of section                                               |
|       `<CR>`       |   `o`   |     `.`      | continue last flash search                                    |                                          |                        |                              | `d<CR><CR>` deletes until next searched text                                     |
|        `b`         |   `o`   |     `.`      | previous word                                                 |                                          |                        |                              | `db` deletes until start of word                                                 |
|        `e`         |   `o`   |     `.`      | next end of word                                              |                                          |                        |                              | `de` deletes until end of word                                                   |
|        `f`         |   `o`   |     `.`      | move to next char                                             |                                          |                        |                              | `df,` deletes until a next `,`                                                   |
|        `F`         |   `o`   |     `.`      | move to previous char                                         |                                          |                        |                              | `dF,` deletes until a previous `,`                                               |
|        `G`         |   `o`   |     `.`      | last line                                                     |                                          |                        |                              | `dG` deletes until last line                                                     |
|        `R`         |   `o`   |     `.`      | treesitter flash search                                       |                                          |                        |                              | `dR,<CR>` deletes next treesitter region that contains `,`                       |
|        `s`         |   `o`   |     `.`      | flash (search with labels in current window)                  |                                          |                        |                              | `ds,<CR>` deletes until next `,`                                                 |
|        `S`         |   `o`   |     `.`      | flash treesitter                                              |                                          |                        |                              | `dS<CR>` deletes treesitter region under cursor position                         |
|        `t`         |   `o`   |     `.`      | move before next char                                         |                                          |                        |                              | `dt` deletes before next `,`                                                     |
|        `T`         |   `o`   |     `.`      | move before previous char                                     |                                          |                        |                              | `dT` deletes before previous `,`                                                 |
|        `w`         |   `o`   |     `.`      | next word                                                     |                                          |                        |                              | `dw.` deletes 2 words                                                            |
|        `W`         |   `o`   |     `.`      | next WORD                                                     |                                          |                        |                              | `dW.` deletes 2 WORDS                                                            |

</details>

## Neovim Motions and Operators

<details><summary></summary>

| Motion/Operator keymap |  Mode   |      repeater key      | Description                                               | requires textobject/motion keymap? (operators requires textobjects/motion) | example when in normal mode                              |
| :--------------------: | :-----: | :--------------------: | :-------------------------------------------------------- | :------------------------------------------------------------------------: | :------------------------------------------------------- |
|          `g[`          | `n`,`x` |                        | +cursor to left around (only textobj with `_` prefix)     |                                    yes                                     | `g]u` go to end to quotation                             |
|          `g]`          | `n`,`x` |                        | +cursor to rigth around (only textobj with `_` prefix)    |                                    yes                                     | `g[u` go to start of quotation                           |
|          `g.`          | `n`,`x` |                        | go to last change                                         |                                                                            |                                                          |
|          `g,`          |   `n`   |                        | go forward in `:changes`                                  |                                                                            |                                                          |
|          `g;`          |   `n`   |                        | go backward in `:changes`                                 |                                                                            |                                                          |
|          `ga`          | `n`,`x` |          `.`           | +align                                                    |                                    yes                                     | `gaip=` will align a paragraph by `=`                    |
|          `gA`          | `n`,`x` |          `.`           | +preview align (escape to cancel, enter to accept)        |                                    yes                                     | `gAip=` will align a paragraph by `=`                    |
|          `gb`          | `n`,`x` |          `.`           | +blackhole register                                       |                                    yes                                     | `gbip` delete a paragraph without copying                |
|          `gB`          | `n`,`x` |          `.`           | blackhole linewise                                        |                                    yes                                     | `gB` delete line                                         |
|          `gc`          | `n`,`x` |          `.`           | +comment                                                  |                                    yes                                     | `gcip` comment a paragraph                               |
|          `gd`          |   `n`   |                        | go to definition                                          |                                                                            |                                                          |
|          `ge`          | `n`,`x` |                        | go to previous end of word                                |                                                                            |                                                          |
|          `gE`          | `n`,`x` |                        | go to previous end of word                                |                                                                            |                                                          |
|          `gf`          |   `n`   |                        | go to file under cursor                                   |                                                                            |                                                          |
|          `gg`          | `n`,`x` |                        | go to first line                                          |                                                                            |                                                          |
|          `gh`          | `n`,`x` |          `.`           | +go to start of textobj                                   |                                    yes                                     | `ghiu` go to start of quotation                          |
|          `gi`          | `n`,`x` |                        | last position of cursor in insert mode                    |                                                                            |                                                          |
|          `gj`          | `n`,`x` |                        | go down (when wrapped)                                    |                                                                            |                                                          |
|          `gJ`          | `n`,`x` |          `.`           | join below line                                           |                                                                            |                                                          |
|          `gk`          | `n`,`x` |                        | go up (when wrapped)                                      |                                                                            |                                                          |
|          `gl`          | `n`,`x` |          `.`           | +go to end of textobj                                     |                                    yes                                     | `gliu` go to end of quotation                            |
|          `gm`          | `n`,`x` |                        | +multiply (duplicate text) operator                       |                                                                            | `gmap` duplicate paragraph withoug modifying clipboard   |
|          `gM`          | `n`,`x` |                        | go to mid line                                            |                                                                            |                                                          |
|          `gn`          | `n`,`x` | `;`forward `,`backward | +next (only textobj with `_` prefix)                      |                                    yes                                     | `gniu` go to next quotation                              |
|          `gp`          | `n`,`x` | `;`forward `,`backward | +previous (only textobj with `_` prefix)                  |                                    yes                                     | `gpiu` go to previous quotation                          |
|          `gq`          | `n`,`x` |          `.`           | +format selection/comments                                |                                    yes                                     | `gqip` format a paragraph                                |
|          `gr`          | `n`,`x` |          `.`           | +replace (with register) Operator                         |                                    yes                                     | `griw` replace word with register (yanked text)          |
|          `gs`          | `n`,`x` |          `.`           | +sort operator                                            |                                    yes                                     | `gsip` sort paragraph                                    |
|          `gS`          | `n`,`x` |          `.`           | split/join arguments                                      |                                                                            |                                                          |
|          `gt`          |   `n`   |                        | go to next tab                                            |                                                                            |                                                          |
|          `gT`          |   `n`   |                        | go to prev tab                                            |                                                                            |                                                          |
|          `gu`          | `n`,`x` |          `.`           | +to lowercase                                             |                                    yes                                     | `guip` lowercase a paragraph                             |
|          `gU`          | `n`,`x` |          `.`           | +to uppercase                                             |                                    yes                                     | `gUip` uppercase a paragraph                             |
|          `gv`          | `n`,`x` |                        | last selected                                             |                                                                            |                                                          |
|          `gw`          | `n`,`x` |          `.`           | +split/join coments/lines 80chars (keeps cursor position) |                                    yes                                     | `gwip` split/join a paragraph by 80 characters           |
|          `gx`          | `n`,`x` |          `.`           | +exchange (text) operator                                 |                                    yes                                     | `gxiw` exchange word with another `gxiw`                 |
|          `gy`          |   `n`   |          `.`           | redo register (dot to paste forward)                      |                                                                            |                                                          |
|          `gY`          |   `n`   |          `.`           | redo register (dot to paste backward)                     |                                                                            |                                                          |
|          `gz`          | `n`,`x` |          `.`           | +surround (followed by a=add, d=delete, r=replace)        |                                    yes                                     | `gzaiw"` add `"`, `gzd"` delete `"`, `gzr"'` replace `"` |
|          `g+`          | `n`,`x` |          `.`           | increment number                                          |                                    yes                                     | `10g+` increment by 10                                   |
|          `g-`          | `n`,`x` |          `.`           | decrement number                                          |                                    yes                                     | `g-` decrement by 1                                      |
|          `=`           | `n`,`x` |          `.`           | +autoindent                                               |                                    yes                                     | `=ip` autoindents paragraph                              |
|          `>`           | `n`,`x` |          `.`           | +indent right                                             |                                    yes                                     | `>ip` indents to right a paragraph                       |
|          `<`           | `n`,`x` |          `.`           | +indent left                                              |                                    yes                                     | `<ip` indents to left a paragraph                        |
|          `$`           | `n`,`x` |                        | end of line                                               |                                                                            |                                                          |
|          `%`           | `n`,`x` |                        | matching character: `()`, `{}`, `[]`                      |                                                                            |                                                          |
|          `0`           | `n`,`x` |                        | start of line                                             |                                                                            |                                                          |
|          `^`           | `n`,`x` |                        | start of line (non-blank)                                 |                                                                            |                                                          |
|          `(`           | `n`,`x` |                        | previous sentence                                         |                                                                            |                                                          |
|          `)`           | `n`,`x` |                        | next sentence                                             |                                                                            |                                                          |
|          `{`           | `n`,`x` |                        | previous empty line (paragraph)                           |                                                                            |                                                          |
|          `}`           | `n`,`x` |                        | next empty line (paragraph)                               |                                                                            |                                                          |
|          `[[`          | `n`,`x` |                        | previous section                                          |                                                                            |                                                          |
|          `]]`          | `n`,`x` |                        | next section                                              |                                                                            |                                                          |
|         `<CR>`         | `n`,`x` |                        | continue last flash search                                |                                                                            |                                                          |
|          `b`           | `n`,`x` |                        | previous word                                             |                                                                            |                                                          |
|          `e`           | `n`,`x` |                        | next end of word                                          |                                                                            |                                                          |
|          `f`           | `n`,`x` |          `f`           | move to next char                                         |                                                                            |                                                          |
|          `F`           | `n`,`x` |          `F`           | move to previous char                                     |                                                                            |                                                          |
|          `G`           | `n`,`x` |                        | last line                                                 |                                                                            |                                                          |
|          `R`           |   `x`   |                        | treesitter flash search                                   |                                                                            |                                                          |
|          `s`           | `n`,`x` |         `<CR>`         | flash (search with labels in current window)              |                                                                            |                                                          |
|          `S`           | `n`,`x` |                        | flash treesitter                                          |                                                                            |                                                          |
|          `t`           | `n`,`x` |          `t`           | move before next char                                     |                                                                            |                                                          |
|          `T`           | `n`,`x` |          `T`           | move before previous char                                 |                                                                            |                                                          |
|          `U`           |   `n`   |                        | repeat `:normal <keys>` or `:<commands>`                  |                                                                            |                                                          |
|          `w`           | `n`,`x` |                        | next word                                                 |                                                                            |                                                          |
|          `W`           | `n`,`x` |                        | next WORD                                                 |                                                                            |                                                          |
|          `Y`           | `n`,`x` |                        | yank until end of line                                    |                                                                            |                                                          |

</details>

## Neovim Space TextObjects/Motions

<details><summary></summary>

|      Keymap       |    Mode     |      repeater key      | Description                                  |
| :---------------: | :---------: | :--------------------: | :------------------------------------------- |
| `<space><space>p` |   `n`,`x`   |          `.`           | Paste after (secondary clipboard)            |
| `<space><space>P` |   `n`,`x`   |          `.`           | Paste before (secondary clipboard)           |
| `<space><space>y` |   `n`,`x`   |                        | yank (secondary clipboard)                   |
| `<space><space>Y` |   `n`,`x`   |                        | yank until end of line (secondary clipboard) |
| `<space><space>j` | `n`,`x`,`o` | `;`forward `,`backward | prev ColumnMove                              |
| `<space><space>k` | `n`,`x`,`o` | `;`forward `,`backward | next ColumnMove                              |

</details>

## Neovim Go to Previous / Next

<details><summary></summary>

|     Keymap      |    Mode     |      repeater key      | Description                                                                                                                                |
| :-------------: | :---------: | :--------------------: | :----------------------------------------------------------------------------------------------------------------------------------------- |
|  `gpc` / `gnc`  | `n`,`o`,`x` | `;`forward `,`backward | previous/next comment                                                                                                                      |
|  `gpd` / `gnd`  | `n`,`o`,`x` | `;`forward `,`backward | previous/next diagnostic                                                                                                                   |
|  `gpf` / `gnf`  | `n`,`o`,`x` | `;`forward `,`backward | previous/next fold (only inside neovim)                                                                                                    |
|  `gph` / `gnh`  | `n`,`o`,`x` | `;`forward `,`backward | previous/next git hunk ([no supported on Windows10](https://github.com/YeferYV/RetroNvim/wiki/Recipies/#gnh-gph-not-working-on-windows10)) |
| `gpaa` / `gnaa` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_argument                                                                                                          |
| `gpab` / `gnab` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_brace                                                                                                             |
| `gpaf` / `gnaf` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_function_call                                                                                                     |
| `gpah` / `gnah` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_html_attribute                                                                                                    |
| `gpak` / `gnak` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_key                                                                                                               |
| `gpam` / `gnam` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_number                                                                                                            |
| `gpao` / `gnao` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_whitespace                                                                                                        |
| `gpaq` / `gnaq` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_quote                                                                                                             |
| `gpat` / `gnat` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_tag                                                                                                               |
| `gpau` / `gnau` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_subword                                                                                                           |
| `gpav` / `gnav` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_value                                                                                                             |
| `gpax` / `gnax` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_hexadecimal                                                                                                       |
| `gpa?` / `gna?` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_user_prompt                                                                                                       |
| `gpia` / `gnia` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_argument                                                                                                          |
| `gpif` / `gnif` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_function_call                                                                                                     |
| `gpih` / `gnih` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_html_attribute                                                                                                    |
| `gpik` / `gnik` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_key                                                                                                               |
| `gpim` / `gnim` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_number                                                                                                            |
| `gpio` / `gnio` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_whitespace                                                                                                        |
| `gpiq` / `gniq` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_quote                                                                                                             |
| `gpit` / `gnit` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_tag                                                                                                               |
| `gpiu` / `gniu` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_subword                                                                                                           |
| `gpiv` / `gniv` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_value                                                                                                             |
| `gpix` / `gnix` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_hexadecimal                                                                                                       |
| `gpi?` / `gni?` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_user_prompt                                                                                                       |

</details>

## Neovim Mini.bracketed

<details><summary></summary>

|       keymap        |    mode     | description                                          |
| :-----------------: | :---------: | :--------------------------------------------------- |
| `[b`/`]b`/`[B`/`]B` | `n`,`o`,`x` | prev/next/first/last buffer                          |
| `[c`/`]c`/`[C`/`]C` | `n`,`o`,`x` | prev/next/first/last comment                         |
| `[x`/`]x`/`[X`/`]X` | `n`,`o`,`x` | prev/next/first/last conflict (only inside neovim)   |
| `[d`/`]d`/`[D`/`]D` | `n`,`o`,`x` | prev/next/first/last diagnostic (only inside neovim) |
| `[f`/`]f`/`[F`/`]F` | `n`,`o`,`x` | prev/next/first/last file                            |
| `[i`/`]i`/`[I`/`]I` | `n`,`o`,`x` | prev/next/first/last indent                          |
| `[j`/`]j`/`[J`/`]J` | `n`,`o`,`x` | prev/next/first/last jump                            |
| `[l`/`]l`/`[L`/`]L` | `n`,`o`,`x` | prev/next/first/last location (only inside neovim)   |
| `[o`/`]o`/`[O`/`]O` | `n`,`o`,`x` | prev/next/first/last oldfile                         |
| `[q`/`]q`/`[Q`/`]Q` | `n`,`o`,`x` | prev/next/first/last quickfix (only inside neovim)   |
| `[t`/`]t`/`[T`/`]T` | `n`,`o`,`x` | prev/next/first/last treesitter                      |
| `[w`/`]w`/`[W`/`]W` | `n`,`o`,`x` | prev/next/first/last window (only inside neovim)     |
| `[y`/`]y`/`[Y`/`]Y` | `n`,`o`,`x` | prev/next/first/last yank                            |

</details>

## Neovim native ctrl keys

<details><summary></summary>

| Key Combination |  mode   | Description                                                                     |
| :-------------: | :-----: | :------------------------------------------------------------------------------ |
|    `ctrl+a`     | `n`,`v` | increase number under cursor                                                    |
|    `ctrl+b`     | `n`,`v` | scroll down by page                                                             |
|    `ctrl+e`     | `n`,`v` | scroll down by line                                                             |
|    `ctrl+d`     | `n`,`v` | scroll down by half page                                                        |
|    `ctrl+f`     | `n`,`v` | scroll up by page                                                               |
|    `ctrl+i`     |   `n`   | jump to next in `:jumps`                                                        |
|    `ctrl+o`     |   `n`   | jump to previous in `:jumps`                                                    |
|    `ctrl+r`     |   `n`   | redo (`u` to undo)                                                              |
|    `ctrl+s`     | `n`,`v` | replace text (using `sed` syntax)(only replaces selected region on visual mode) |
|    `ctrl+u`     | `n`,`v` | scroll up by half page                                                          |
|    `ctrl+v`     | `n`,`v` | visual block mode                                                               |
|    `ctrl+x`     | `n`,`v` | decrease number under cursor                                                    |
|    `ctrl+y`     | `n`,`v` | scroll up by line                                                               |

</details>

## Neovim Editor keymaps

<details><summary></summary>

|     Key Combination      |  mode   | Description                                               |
| :----------------------: | :-----: | :-------------------------------------------------------- |
|         `ctrl+\`         |   `n`   | Toggle (terminal) visibility                              |
|         `<esc>`          |   `n`   | clear search highlight                                    |
|       `<esc><esc>`       |   `t`   | terminal normal-mode (when inside neovim's terminal)      |
|           `i`            |   `t`   | terminal exit normal-mode (when inside neovim's terminal) |
|        `<space>`         |   `n`   | Show whichkey menu                                        |
|   `<space><backspace>`   |   `n`   | Show more whichkey entries                                |
|       `<space>o?`        |   `n`   | open file explorer (neotree) and show keybindings         |
|           `jk`           |   `i`   | send Escape                                               |
|         `alt+h`          | `i`,`x` | Send Escape                                               |
|        `shift+h`         |   `n`   | Type `10h`                                                |
|        `shift+j`         |   `n`   | Type `10gj`                                               |
|        `shift+k`         |   `n`   | Type `10gk`                                               |
|        `shift+l`         |   `n`   | Type `10l`                                                |
|          `left`          |   `n`   | Go to previous editor                                     |
|         `right`          |   `n`   | Go to next editor                                         |
| `alt+left` or `alt+down` |   `n`   | Decrease view size                                        |
| `alt+right` or `alt+up`  |   `n`   | Increase view size                                        |
|         `ctrl+h`         |   `n`   | Navigate to left window                                   |
|         `ctrl+j`         |   `n`   | Navigate to down window                                   |
|         `ctrl+k`         |   `n`   | Navigate to up window                                     |
|         `ctrl+l`         |   `n`   | Navigate to right window                                  |
|        `shift+q`         |   `n`   | Close active editor                                       |
|        `shift+r`         |   `n`   | Format and save                                           |

</details>

## Neovim Suggestion keymaps

<details><summary></summary>

| Key Combination | mode | Description                     |
| :-------------: | :--: | :------------------------------ |
|  `ctrl+space`   | `i`  | Toggle suggestion widget        |
|     `alt+j`     | `i`  | Show next inline suggestion     |
|     `alt+k`     | `i`  | Show previous inline suggestion |
|     `alt+l`     | `i`  | Commit inline suggestion        |

</details>

---

## LF terminal file manager

<details><summary></summary>

|       keymap       | description                                                                |
| :----------------: | :------------------------------------------------------------------------- |
|        `l`         | open file or selected files with $EDITOR/mpv/$OPENER                       |
|        `i`         | open image/text in pager (pager doesn't render images inside zellij)       |
|        `o`         | play image/video/pdf in mpv-sixel (mpv-sixel doesn't render inside zellij) |
|       `gll`        | open lazygit                                                               |
|       `gfs`        | fuzzy find files names and cd                                              |
|       `gfr`        | fuzzy find files content with ripgrep                                      |
|     `<enter>`      | run shell commands                                                         |
|        `D`         | move to trash                                                              |
|        `J`         | go down 10 times                                                           |
|        `K`         | go up 10 times                                                             |
|        `Y`         | copy path                                                                  |
|       `:doc`       | to see [all keymaps](https://github.com/gokcehan/lf/blob/master/doc.md)    |
| `<most used keys>` | [tutorial](https://github.com/gokcehan/lf/wiki/Tutorial)                   |

</details>

---

## zsh keymaps

<details><summary></summary>

|    keymap    | description                                                |
| :----------: | :--------------------------------------------------------- |
|   `<tab>`    | show (dash/path) options or complete path                  |
| `<tab><tab>` | enter completion menu                                      |
| `<esc><esc>` | tmux-copy-mode-like / normal-mode (inside neovim terminal) |
|   `alt+o`    | open yazi (even while writing commands)                    |
|   `alt+y`    | open yazi                                                  |
|   `alt+h`    | enter vim mode                                             |
|   `alt+j`    | previous history and enter vim-mode                        |
|   `alt+k`    | next history and enter vim-mode                            |
|   `alt+l`    | complete suggestion and enter vim-mode                     |
|   `ctrl+r`   | search history with fzf                                    |
|   `ctrl+l`   | clear screen                                               |
| `ctrl+alt+l` | clear screen (inside neovim terminal)                      |

</details>

---

## Installation

<details open><summary></summary>

```bash
git clone --recursive https://github.com/YeferYV/sixelrice ~/.config/nvim
ln -s  ~/.config/nvim/lf                                   ~/.config/lf
ln -s  ~/.config/nvim/mpv                                  ~/.config/mpv
ln -s  ~/.config/nvim/zsh                                  ~/.config/zsh
ln -s  ~/.config/nvim/zsh/.zshrc                           ~/.zshrc
source ~/.zshrc # to download the dependencies using pixi # wezterm can display icons by default
```

tested on wezterm on x11/xorg with pipewire on archlinux

</details>

## Treesitter Installation (optional)

<details open><summary></summary>

- Text objects that has a `@` prefix requires a treesitter parser, neovim version `0.10` or newer comes with treesitter parsers for
  `c`, `lua`, `markdown`.
  Install treesitter parser for your programming language with `:TSInstall <your programming language>`

- Example: in normal mode type `:` to open vim-command-line then type `TSInstall cpp`

- Tip: to make a clean tressitter parser installation remove the folder.

</details>

## Vim Cheatsheets

<details open><summary></summary>

- [devhints.io/vim](https://devhints.io/vim) most used vim keys
- [viemu.com](http://www.viemu.com/a_vi_vim_graphical_cheat_sheet_tutorial.html) vim keys from A-Z
- [vscode with embedded neovim](https://www.youtube.com/watch?v=g4dXZ0RQWdw) youtube tutorial most of the keybindings are similar to sixelrice's neovim
- [treesitter text-objects demo](https://www.youtube.com/watch?v=FuYQ7M73bC0) youtube tutorial the keybindings are similar to sixelrice's neovim
- [treesitter text-objects extended](https://www.youtube.com/watch?v=CEMPq_r8UYQ) youtube tutorial the keybindings are similar to sixelrice's neovim
- [text-objects from A-Z](https://www.youtube.com/watch?v=JnD9Uro_oqc) youtube tutorial the keybindings are similar to sixelrice's neovim
- [motion-operators from A-Z](https://www.youtube.com/watch?v=HhZJ1kbzkj0) youtube tutorial the keybindings are the same as to sixelrice's neovim

</details>

## Related projects

<details open><summary></summary>

- [yeferyv/retronvim](https://github.com/yeferyv/retronvim) vscode extension with neovim text objects from A-Z + LSP whichkey + touchcursor keyboard layout
- [yeferyv/archrice](https://github.com/yeferyv/archrice) arch linux rice with neovim text object from A-Z, based on [mini.nvim](https://github.com/echasnovski/mini.nvim)
- [yeferyv/dotfiles](https://github.com/yeferyv/dotfiles) my dotfiles (minimal archrice + keybindings for managing windows in any desktop environment) with archlinux, debian and windows support/installer

</details>
