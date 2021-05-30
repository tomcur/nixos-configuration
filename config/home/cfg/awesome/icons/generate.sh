#!/usr/bin/env bash

for filename in base/*.svg; do
    filename=$(basename $filename)
    filename="${filename%.*}"

    cp base/$filename.svg $filename.svg
    cp base/$filename.svg $filename-focus.svg
    cp base/$filename.svg $filename-hover.svg
    cp base/$filename.svg $filename-focus-hover.svg
    cp base/$filename.svg $filename-press.svg
    cp base/$filename.svg $filename-focus-press.svg

    sed -i 's/#262626/#545454/g' $filename.svg
    sed -i 's/#262626/#848484/g' $filename-hover.svg
    sed -i 's/#262626/#343434/g' $filename-press.svg
    sed -i 's/#262626/#262626/g' $filename-focus.svg
    sed -i 's/#262626/#565656/g' $filename-focus-hover.svg
    sed -i 's/#262626/#161616/g' $filename-focus-press.svg
done
