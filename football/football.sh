#! /bin/zsh

sport_name=football

# get compets
req=$(curl -i -s http://www.comparateur-de-cotes.fr/comparateur/$sport_name)
code=$(echo $req | egrep -m1 "^HTTP" | egrep -o "[0-9]{3}")
[[ $(echo $code) != 200 ]] && echo "Erreur requete code : $code" && exit 4
#echo $req

compets_name=($(echo $req | grep -o "<a href=\"comparateur/$sport_name/.*\"><" | grep -o "/[^/]*\"" | tr -d "/\""))
[[ -z "$compets_name[1]" ]] && echo "Pas d'entree pour la compet 1 de $sport_name. Verifiez compets_name" && exit 4
#echo $compets_name && exit

# request each compet
for compet in $compets_name ;
do
	echo $compet
	#[[ $compet != "France-Ligue-1-ed3" ]] && continue
	curl -i -s http://www.comparateur-de-cotes.fr/comparateur/$sport_name/$compet > "$sport_name/req_$compet"
	code=$(cat $sport_name/req_$compet | egrep "^HTTP" | egrep -o "[0-9]{3}")
	[[ $(echo $code) != 200 ]] && echo "Erreur requete pour : $compet avec code : $code" && exit 6
done

echo "\033[1;43m$sport_name\033[m" && exit

#./tennis/2_tennis.sh $compets_name