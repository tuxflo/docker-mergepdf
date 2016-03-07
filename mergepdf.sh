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
  until err_str=$(lsof $1 2>&1 >/dev/null); do
    if [ -n "$err_str" ]; then
      # lsof printed an error string, file may or may not be open
      echo "lsof: $err_str" >&2

      # tricky to decide what to do here, you may want to retry a number of times,
      # but for this example just break
      break
    fi

    # lsof returned 1 but didn't print an error string, assume the file is open
    sleep 1
  done

  if [ -z "$err_str" ]; then
    # file has been closed, move it
    mv $1 $OUTPUT
  fi
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
  pdftk A=$stringOdd B=$stringEven shuffle A Bend-1 output $OUTPUT/$stringMerged
  rm  -f $stringOdd $stringEven
  sleep 2 #needed when copying multiple files into the Input folder
  exit
fi

