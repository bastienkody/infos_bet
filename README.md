# Infos_bet
Scrap infos about sports bets

## Config file
Outfile (mandatory) and max accepted odds (optional) are specified in "config_infos_bet.txt" 

### Outfile
`outfile=result.txt` for result.txt as outfile

`outfile=/dev/stdout` for terminal screen (no outfile)

### Max odds
`football=1.90` green print football matches with odds under 1.90

`tennis=1.50` green print tennis matches with odds under 1.90


## Start the script 
`./launch.sh`

## Results format
Sport name -> Competition (matchs nb) -> Matchs infos : date, teams and odds

Odds can be colored green or red according to the max odds limit per sport

Color code according to rank is not yet available

Errors (mostly related to curl) are printed in the outfile. Would it be better on stdout?

### On Today (april 13th 2023)
Tennis : avaible for men, wmen, double. no ranking for wmen and double

Football : avaible for A LOT of compet. no ranking at all
