#!/bin/sh
mkdir -p target
rm target/*
latex -output-directory=target outline.tex && \
biber --output_directory=target outline && \
latex -output-directory=target outline.tex && \
latex -output-directory=target outline.tex && \
pdflatex -output-directory=target outline.tex
