# docker-mergepdf
Docker container that watches a folder for odd and even pdf files and merges them via pdftk. Good for NAS systems like where installing a docker container is way more easy than building gcc-gcj and pdftk.

## usage
The container expects a volume `/srv/input` as the folder that is watched and `/srv/output` as the folder for the merged file. The current syntax expects a file that ends with `_o.pdf` (for odd) containing the odd pages of a dualside scan and a file ending with `_e.pdf` for the even pages. As you can see in the executed script `mergepdf.sh` pdftk is called with the `shuffle A Bend-1` parameter. That means one could first scan all odd pages than turn arround the whole staple of sheets and scan the even pages beginning with the last page.
