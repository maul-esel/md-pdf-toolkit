#!/usr/bin/env bash

file=$1
DIR=$PWD

base=${file%.md}
pdf_file=$base.pdf
html_file=$base.html
end_file=$base-Loesung.pdf

TMP_DIR="tmp-build-solution"
rm -rf "$TMP_DIR"
cp -r "bootstrap" "$TMP_DIR"

# workaround
content=$(cat "$file")
content=${content//ä/&auml;}
content=${content//ö/&ouml;}
content=${content//ü/&uuml;}
content=${content//Ä/&Auml;}
content=${content//Ö/&Ouml;}
content=${content//Ü/&Uuml;}
content=${content//ß/&szlig;}

cd "$TMP_DIR"

echo "date: '$base'" >> "_config.yml"
echo -e "---\nlayout: default\n---" > "$file"
echo "$content" >> "$file"

jekyll build
cd _site

wkhtmltopdf --use-xserver --margin-top 1cm --margin-bottom 1cm "$html_file" --footer-center "[page]/[topage]" --footer-line --footer-spacing 5 --header-left "Übung 10 Team 5" --header-right "Informatik Übungen $base" --header-spacing 5 --header-line "$pdf_file"
cp "$pdf_file" "$DIR/$end_file"

cd "$DIR"
rm -rf "$TMP_DIR"