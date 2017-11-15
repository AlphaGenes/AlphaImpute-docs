pandoc --standalone --smart --from=markdown+yaml_metadata_block+inline_notes --template=latex_template.tex --natbib --filter pandoc-tablenos --filter pandoc-fignos chapters/00-title-page-small.md chapters/00-front-matter.md chapters/01-small-intro.md  chapters/10-quick-reference.md chapters/99-bibtex-appendix.md -o small.tex

pdflatex small
bibtex small
makeindex small
pdflatex small
pdflatex small

