# Decliner
World of Warcraft addon to add an "Always Decline" button to quests to thwart trolls who would troll by sharing irrelvent quests

This add on exists in a very simple state, the only graphical element is the "Always Decline" button added to the quest offer window. All further interaction with this addon is done through `/decliner <command>`

Available commands are

`/decliner help` print a list of available commands

`/decliner list` print a list of quests currently being auto-declined

`/decliner remove <questid>` remove a quest from the list of quests to auto-decline

`/decliner saymode` print the current saymode

`/decliner saymode <mode>` set the saymode for Decliner this sets when auto-declined quests are announced

SayModes are as follows:

- `always` : always announce an auto-declined quest

- `never` : never announce an auto-declined quest

- `timed` : don't announced more than one auto-declined quest per minute

