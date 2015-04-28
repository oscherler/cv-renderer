# CV Renderer

This repository contains the scripts used to generate my CV from a single XML file to PDF, HTML and text in each language.

## Usage

Clone the git repository:

	git clone git@github.com/oscherler/cv-renderer
	cd cv-renderer

Run `setup.sh` to download FOP and the source XML file for the CV:

	./setup.sh

Generate the CV in the desired formats using any of the following commands:

	make pdf
	make html
	make text
	make all
