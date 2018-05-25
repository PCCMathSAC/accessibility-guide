## ********************************************************************* ##
## Copyright 2018                                                        ##
## American Institute of Mathematics                                     ##
##                                                                       ##
## GNU General Public License, see <http://www.gnu.org/licenses/>.       ##
##                                                                       ##
## ********************************************************************* ##

##################################
# DO NOT EDIT THIS FILE (Makefile)
##################################

#   1) Do make a copy of Makefile.paths.distribution
#      as Makefile.paths
#   2) Edit Makefile.paths as directed there
#   3) This file (Makefile) and Makefile.paths.original
#      are managed by revision control and edits will conflict

##############
# Introduction
##############

# This is not a "true" makefile, since it does not
# operate on dependencies.  It is more of a shell
# script, sharing common configurations

######################
# System Prerequisites
######################

#   install         (system tool to make directories)
#   xsltproc        (xml/xsl text processor)
#   jing-trang      (only to validate PTX source)
#   <helpers>       (PDF viewer, web browser)

#####
# Use
#####

#	A) Set directory to be the location of this file
#	B) At command line:  make <some-target>

# The included file contains customized versions
# of locations of the principal components of this
# project and names of various helper executables
include Makefile.paths

# These paths are subdirectories of
# the PreTeXt distribution
PTXXSL = $(PTX)/xsl

# XML to apply templates to
PRJSRC = $(PROJECT)/src/accessibility-guide.ptx

# These paths are subdirectories of
# the scratch directory
HTMLOUT    = $(SCRATCH)/html
PDFOUT     = $(SCRATCH)/pdf


################
#Targets for make
################

# LaTeX and PDF versions

pdf:
	install -d $(PDFOUT)
	-rm $(PDFOUT)/*.*
	cd $(PDFOUT); \
	xsltproc $(PTXXSL)/mathbook-latex.xsl $(PRJSRC) \
	xelatex accessibility-guide.tex; \
	xelatex accessibility-guide.tex; \
	open accessibility-guide.pdf; \


# HTML output
# See prerequisite above about merge files.
html:
	install -d $(HTMLOUT)
	-rm $(HTMLOUT)/*.html
	-rm $(HTMLOUT)/knowl/*.html
	cd $(HTMLOUT); \
	xsltproc $(PTXXSL)/mathbook-html.xsl $(PRJSRC); \
	open -a $(HTMLVIEWER) index.html;


###########
# Utilities
###########

# Verify Source integrity
#   Leaves "jingreport.txt" in SCRATCH
#   Automatically invokes the "less" pager, could configure as $(PAGER)
check:
	install -d $(SCRATCH)
	-rm $(SCRATCH)/jingreport.txt
	-java -classpath $(JINGTRANG) -Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration -jar $(JINGTRANG)/jing.jar $(PTX)/schema/pretext.rng $(PRJSRC) > $(SCRATCH)/jingreport.txt
	less $(SCRATCH)/jingreport.txt

