#! /bin/zsh

sport_name=football
outfile=$1

# get compets
req=$(curl -i -s http://www.comparateur-de-cotes.fr/comparateur/$sport_name)
code=$(echo $req | egrep -m1 "^HTTP" | egrep -o "[0-9]{3}")
[[ $(echo $code) != 200 ]] && echo "Erreur requete (main page $sport_name) code : $code" >> $outfile && exit 4
#echo $req

compets_name=($(echo $req | grep -o "<a href=\"comparateur/$sport_name/.*\"><" | grep -o "/[^/]*\"" | tr -d "/\""))
[[ -z "$compets_name[1]" ]] && echo "Pas d'entree pour la compet 1 de $sport_name. Verifiez compets_name" >> $outfile && exit 5
#echo $compets_name && exit

# request each compet
for compet in $compets_name ;
do
	#echo $compet
	#[[ $compet != "France-Ligue-1-ed3" ]] && continue
	curl -i -s http://www.comparateur-de-cotes.fr/comparateur/$sport_name/$compet > "$sport_name/req_$compet"
	code=$(cat $sport_name/req_$compet | egrep "^HTTP" | egrep -o "[0-9]{3}")
	[[ $(echo $code) != 200 ]] && echo "Erreur requete pour : $compet avec code : $code" >> $outfile && exit 6
done

name=$(echo $sport_name | tr "[a-z]" "[A-Z]")
echo "\033[1;43m$name\033[m" >> $outfile

./football/2_football.sh "$compets_name" "$outfile"

echo "\033[1;43mEND - $name\033[m" >> $outfile
echo "--------------------------------------------------------------------------------" >> $outfile
echo "--------------------------------------------------------------------------------" >> $outfile
