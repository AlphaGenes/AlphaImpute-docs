pandoc --standalone --smart --from=markdown+yaml_metadata_block+inline_notes --template=latex_template.tex --natbib --filter pandoc-tablenos --filter pandoc-fignos chapters/00-title-page-small.md chapters/01-small-intro.md  chapters/30-example01.md chapters/20-faq.md chapters/10-quick-reference.md chapters/00-front-matter.md -o small.tex

if %ERRORLEVEL% NEQ 0 (
  echo "Pandoc stopped."
   exit /b %ERRORLEVEL%
)

pdflatex small
bibtex small
makeindex small
pdflatex small
pdflatex small

