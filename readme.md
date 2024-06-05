#

So how this works.



-When you approach, you use a security card near a panel to activate a minigame(currently turned off, can be turned back on via config)
-once the door is opened the player state keeps track of your progress to spawn the lockers so people can't just loot it wherever
-you then thermite the door which opens after the animation and explosion(yes I know the coords are fucky). States update again.
-loot all spots.

how some of the logic works

-so instead of networking the movements of the bank vault door, I made a change in the config that when the panel hack is done it changes the isOpen bool to true
-each client then reads that state and keeps the door open. (I was having an issue with doors being opened for other clients, and things not networking. Probably did it wrong. No one was answering me when I asked for help)
-then when the door is open a timer starts that then marks the isOpen bool to false once it expires, which should reset the doors to its natural positions

And now the issues im having

-vault headings set to 0 heading despite being explicitly told to sit at other headings (openHeading etc.)
-if you run away from the door(usually further than 25 generic gta units) it would reset to natural positions despite all the code telling it otherwise(this is why I used a config based networking solution instead of just plopping -1 in each event.)
-It seems resetting things so that the bank is robbable again in X amount of time wont work... might take a server reset. I'd rather it fully reset without having to restart a script or a server.


