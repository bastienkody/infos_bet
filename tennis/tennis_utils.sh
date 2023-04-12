function hexascii_to_deci()
{
	ref_file=utils/hex_ascii_html.txt
	deci=""
	char_nb=$(echo $first_cote | grep -o ";" | wc -l | tr -d "[:blank:]")
	j=1
	while [[ $j -le $char_nb ]] ; 
	do
		deci+=$(cat $ref_file | grep "$(echo $first_cote | cut -d';' -f$j)" | cut -d' ' -f1)
		j=$(($j+1))
	done
	echo -n $deci
}

function print_colorz_bet()
{
	if [[ $first_cote -le $max_cote ]] || [[ $second_cote -le $max_cote ]] ;
	then
		echo "\033[42m$first_cote - $second_cote \033[m"
	else
		echo "\033[41m$first_cote - $second_cote \033[m"
	fi
}

# RANKING (wmen ranking not managed)
ranking_site_m=https://www.tennisendirect.net/atp/classement/
ranking_men_data=$(curl -i -s $ranking_site_m)
code_m=$(echo $ranking_men_data | egrep -m1 "^HTTP" | egrep -o "[0-9]{3}")
[[ $(echo $code_m) != 200 ]] && echo "Erreur requete ranking men, code : $code_m" && exit 4

ranking_site_w=https://www.tennisendirect.net/wta/classement/
ranking_women_data=$(curl -i -s $ranking_site_w)
code_w=$(echo $ranking_women_data | egrep -m1 "^HTTP" | egrep -o "[0-9]{3}")
[[ $(echo $code_w) != 200 ]] && echo "Erreur requete ranking women, code : $code_w" && exit 4

name_err=tennis/name_correctif.txt

function get_rank
{
	cat $name_err | grep -q -i $1 && 1=$(cat $name_err | grep -i $1 | cut -d'>' -f2)
	res=$(echo $ranking_men_data | sed s/"<tr"/\\n/g | grep -i "$1" | egrep -o "class=\"w20\">[0-9]{1,3}" | cut -d'>' -f2 | uniq)
	[[ -z $res ]] && echo "NO RANKING FOUND" || echo $res
}
