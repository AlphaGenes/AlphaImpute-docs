REM  pandoc --standalone --smart --from=markdown+yaml_metadata_block --template=latex_template.tex chapters/00-front-matter.md -o small.tex
REM --standalone --smart --from=markdown+yaml_metadata_block --template=latex_template.tex --bibliography=bibliography.bib chapters/00-front-matter.md -o small.pdf
pandoc --standalone --smart --from=markdown+yaml_metadata_block --template=latex_template.tex --natbib chapters/00-title-page-small.md chapters/00-front-matter.md chapters/01-small-intro.md -o small.tex

pdflatex small
bibtex small
makeindex small
pdflatex small
pdflatex small

