#! /bin/zsh 

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
	if [[ $first_cote -le $max_cote ]] || [[ $second_cote -le $max_cote ]] || [[ $third_cote -le $max_cote ]] ;
	then
		echo "\033[42m$first_cote - $second_cote - $third_cote\033[m" >> $outfile
	else
		echo "\033[41m$first_cote - $second_cote - $third_cote\033[m" >> $outfile
	fi
}

# RANKING PREP // NOT WORKING AT ALL & PROBABLY WILL NEVER
function ranking_prep()
{
	ranking_site=https://www.foot-direct.com
	ranking_main_data=$(curl -i -s $ranking_site/classement)
	code_m=$(echo $ranking_main_data | egrep -m1 "^HTTP" | egrep -o "[0-9]{3}")
	[[ $(echo $code_m) != 200 ]] && echo "Erreur requete ranking main page for $sport_name, code : $code_m" && exit 4

	championships=($(echo $ranking_main_data | egrep "href.*#tabStandings\" >" | grep -o "\".*\"" | tr -d "\""))
	#echo $championships

	for c in $championships ;
	do
		echo "$ranking_site$c"
		req=$(curl -i -s $ranking_site$c)
		code_c=$(echo $req | egrep -m1 "^HTTP" | egrep -o "[0-9]{3}")
		[[ $(echo $code_c) != 200 ]] && echo "Erreur requete ranking for compet $c for $sport_name, code : $code_c" && continue
		c=$(echo "$c" | tr "/" "_")
		echo $req | grep -m3 -A 1000 "<tbody>" | tail -n 1000 | sed -n '/<\/tbody/q;p' > "ranking/"$c"_rank"
		cat ranking/"$c"_rank | grep -A 4 "<td class=\"standings__rank\"" | egrep -o "([0-9]{1,2}|equipe/[0-9A-Za-z_-]*)" | sed s'/equipe\///g'
	done
}

function get_rank()
{
	cat $name_err | grep -q -i $1 && 1=$(cat $name_err | grep -i $1 | cut -d'>' -f2)
	res=$(echo $ranking_men_data | sed s/"<tr"/\\n/g | grep -i "$1" | egrep -o "class=\"w20\">[0-9]{1,3}" | cut -d'>' -f2 | uniq)
	[[ -z $res ]] && echo "NO RANKING FOUND" || echo $res
}
