# Infos_bet
Scrap infos about bets for testing a safe betting strategy

## Max cote
A file ".max_cote_infos_bet.txt" is needed in home repo (~/)

It stores infos in format "sportname=yx.xx" (x and y digits, y is optional)

## Outfile
In launch.sh, assign the outfile variable

ie: `outfile=result.txt` for result.txt as outfile

ie: `outfile=/dev/stdout` for terminal screen (no outfile)

## Start the script 
`./launch.sh`

## Results format
Sport -> nb matchs in competition -> all matchs : Date, teams and cotes

Cotes are green or red according to the max cote limit per sport

Color code according to rank is not yet available

Errors (mostly related to curl) are printed in the outfile

### On Today (april 13th 2023)
Tennis : avaible for men, wmen, double. no ranking for wmen and double

Football : avaible for A LOT of compet. no ranking at all
