#!/bin/sh

fop_url='http://mirror.easyname.ch/apache/xmlgraphics/fop/binaries/fop-1.1-bin.tar.gz'
cv_url='http://olivier.ithink.ch/cv/Source%20CV.xml'
cv_destination='cv-multilingual.xml'

echo 'Downloading and decompressing fop-1.1.'
echo 

curl "${fop_url}" | tar xz

echo "Downloading CV XML (answer y when asked to replace an existing ${cv_destination} file."
echo 

curl "${cv_url}" > "${cv_destination}.tmp"

mv -i "${cv_destination}.tmp" "${cv_destination}"
