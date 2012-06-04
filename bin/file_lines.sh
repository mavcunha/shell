. ~/.bash_profile
ff $1  | while read line; do wc -l "${line}"; done | cut -d'.' -f1 | tr -s " " | awk  '{s+=$1}END{print s}'
