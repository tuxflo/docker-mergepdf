#!/bin/bash
INPUT=/srv/input
OUTPUT=/srv/output

cd $INPUT

if [[ $1 != *.pdf ]]; then
  #not a pdf file, do nothing
  exit
fi

if [[  "$1" != *_o.pdf && "$1" != *_e.pdf  ]]; then
  #no multipage pdf file, move directly to Output folder
  #sleep 25
  RC=1 
  while [[ $RC -ne 0 ]]
  do
    rsync -a $1 $OUTPUT
    RC=$?
  done
  rm -f $1
  exit
fi

if [[ "$1" == *_o.pdf ]]; then
  stringOdd=$(basename "$1")
  stringEven=${1/%_o.pdf/_e.pdf}
else
  #even file created first for some reason
  stringOdd=${1/%_e.pdf/_o.pdf}
  stringEven=$(basename "$1")
fi

stringMerged=${stringOdd/%_o.pdf/_merged.pdf}

if [[ -f $stringOdd && -f $stringEven ]]; then
  sleep 5
  pdftk A=$stringOdd B=$stringEven shuffle A Bend-1 output $OUTPUT/$stringMerged
  rm  -f $stringOdd $stringEven
  sleep 2 #needed when copying multiple files into the Input folder
  exit
fi

