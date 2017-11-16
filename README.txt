# AlphaImpute-docs README

This README file is *not* for AlphaImpute.
This README file is for the AlphaImpute *manuals*.

Manuals are written in Markdown.

For printable editions, manuals are compiled using **pandoc** and **LaTeX**.
Pandoc requires some additional extensions.
`pandoc-tablenos` and `pandoc-fignos` for ennumerating figure and table captions.


Organization:
/             - scripts for compiling various versions of the manuals.
/chapters/    - each chapter can be found as a separate file.
/examples/    - examples used in the manuals, complete with input data and spec files.
/figures/     - figures for manuals.


## Numbering and referencing figures and tables

To set a caption for a table:

```
Table: Caption {#tbl:lbl} 
```
`Table` is mandatory (I believe). Curly brackets must appear at end.

To reference the table use `@tbl:lbl`.

To set a caption for a figure:

```
![Figure-caption](filename){#fig:lbl}
```

To reference the figure use `@fig:lbl`.

### Installation:

Run python installers as root / administrator:

```
pip install pandoc-tablenos 
pip install pandoc-fignos
``` 

* pandoc-fignos: https://github.com/tomduck/pandoc-fignos
* pandoc-tablenos: https://github.com/tomduck/pandoc-tablenos

