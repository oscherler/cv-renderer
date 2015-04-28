#!/bin/sh

fop_url='http://mirror.easyname.ch/apache/xmlgraphics/fop/binaries/fop-1.1-bin.tar.gz'

echo 'Downloading and decompressing fop-1.1.'
echo 

curl "${fop_url}" | tar xz
