#! /bin/zsh

sport_name=tennis

req=$(curl -s http://www.comparateur-de-cotes.fr/comparateur/$sport_name)
#echo $req

compets=($(echo $req | grep -o "<a href=\"comparateur/$sport_name/.*\"><" | grep -o "/[^/]*\"" | tr -d "/\""))
#echo $compets

#curl -s http://www.comparateur-de-cotes.fr/comparateur/$sport_name/$compets[1]

for compet in $compets ;
do
	#req_s+=($(curl -s 
	echo " http://www.comparateur-de-cotes.fr/comparateur/$sport_name/$compet"
done

for r in $req_s ;
do
	#echo $r
	#echo "NEXT ------------_____---------________-------- NEXT\n\n\n\n\n"
done
