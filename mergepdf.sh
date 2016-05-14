#!/bin/bash
INPUT=/srv/input
OUTPUT=/srv/output

cd $INPUT

if [[ $1 != *.pdf ]]; then
  echo "not a pdf file, do nothing"
  exit
fi

if [[  "$1" != *_o.pdf && "$1" != *_e.pdf  ]]; then
  #no multipage pdf file, copy directly to Output folder
  echo "detected non mutlipage file"
  TMP=0
  until [ $TMP -eq $(stat -c %s $1) ]
  do
    TMP=$(stat -c %s $1)
    sleep 5
  done
  sleep 25
  echo "copied to output"
  cp $1 $OUTPUT
  sleep 3
  mv --backup=t $1 $1_bkp
  echo "moved to $1_bkp"
  exit
fi

if [[ "$1" == *_o.pdf ]]; then
  echo "odd file detected"
  stringOdd=$(basename "$1")
  stringEven=${1/%_o.pdf/_e.pdf}
else
  #even file created first for some reason
  echo "even file detected"
  stringOdd=${1/%_e.pdf/_o.pdf}
  stringEven=$(basename "$1")
fi

stringMerged=${stringOdd/%_o.pdf/_merged.pdf}
  echo "merged sting $stringMerged"

if [[ -f $stringOdd && -f $stringEven ]]; then
  sleep 15
  echo "executing pdftk"
  pdftk A=$stringOdd B=$stringEven shuffle A Bend-1 output $OUTPUT/$stringMerged
  sleep 3
  echo "removing files"
  #rm  -f $stringOdd $stringEven
  mv $stringOdd $stringOdd_bkp
  mv $stringEven $stringEven_bkp
  sleep 2 #needed when copying multiple files into the Input folder
  echo "done..."
  exit
fi

