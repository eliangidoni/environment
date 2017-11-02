#!/usr/bin/env bash

if [ $# -eq 1 ]; then
    echo "Generating doxygen docs..."
    which dot > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        brew install graphviz;
    fi
else
    echo "$0 <project_path>"
    exit 1;
fi

PROJECT_PATH=$1
PROJECT_NAME=`basename $PROJECT_PATH`
OUTPUT_DIR=${PROJECT_NAME}_code_reference

cat <<EOF > doxygen_tmp.in
PROJECT_NAME = ${PROJECT_NAME}
INPUT = ${PROJECT_PATH}/
# FILE_PATTERNS = *.hh *.cc *.h *.c *.hpp *.cpp *.tcc
EXCLUDE_PATTERNS = */test/* */unittest/* */tests/* */unittests/* */env/include/* */env/lib/*
OUTPUT_DIRECTORY = ${OUTPUT_DIR}
RECURSIVE = YES
HAVE_DOT = YES
CALL_GRAPH = YES
CALLER_GRAPH = YES
EXTRACT_ALL = YES
EXTRACT_PRIVATE = YES
EXTRACT_STATIC = YES
EXTRACT_PACKAGE = YES
EXTRACT_LOCAL_CLASSES = YES
EXTRACT_LOCAL_METHODS = YES
SOURCE_BROWSER = YES
VERBATIM_HEADERS = NO
ALPHABETICAL_INDEX = YES
GENERATE_TREEVIEW = YES
DISABLE_INDEX = YES
GRAPHICAL_HIERARCHY = YES
DIRECTORY_GRAPH = YES
CLASS_GRAPH = YES
COLLABORATION_GRAPH = NO
GROUP_GRAPHS = YES
MAX_DOT_GRAPH_DEPTH = 2
UML_LOOK = YES
GENERATE_LATEX = NO
GENERATE_HTML = YES
EOF

cat doxygen_tmp.in && doxygen doxygen_tmp.in && rm doxygen_tmp.in;

cat <<EOF > ${OUTPUT_DIR}/index.html
<html><head><title>${PROJECT_NAME} code reference</title></head><body><p>Nice, bookmark this page !</p><p>See code for <a href=html/index.html>${PROJECT_NAME}</a></p></body></html>
EOF

open file://${PWD}/${OUTPUT_DIR}/index.html
