# IntroAI_Assignment1
Assignment 1 for Introduction to Artificial Intelligence in Innopolis University.\
Implementation of Wumpus World with Prolog.\
Grade: 20/20.

## Introduction
The prolog file is called WumpusWorld.pl, and to execute the code one has to load the file with Swipl and query “play”. It plays on a 5x5 board and the examples following are also in a 5x5 board. However, the size of the board can be changed, but the number of pits has to be increased in order to reduce the number of possible paths. \
Once the query is executed, the program will print the board and the first solution (if there is at least one). Each solution will print the board with the path taken by the player, the list of moves and the number of moves the player did. It also prints if the Wumpus was killed or not. The program is capable of printing all possible paths. \
The agent is a very safe player, they would avoid pits when the breeze is perceived. During early development, they avoided the Wumpus too but afterwards, they would shoot to all directions to kill the Wumpus. The player never dies before backtracking. \

Before starting, I would like to explain what the symbols on the board mean in table 1.1.

| Symbol | Meaning |
| :--: | -- | 
| _ | Empty Cell |
| W | Alive Wumpus |
| P | Pit |
| % | Visited Dead Wumpus |
| O | Visited Cell |
| X | Dead Wumpus |
| G | Gold | 

**Table 1.1.** Meaning of the board symbols.

## Implementation & Testing
The first test board was an empty board, only with the gold, to check if the game finished and if it printed the map with the path followed by the player. This showed a bug caused by the implications in the printing rules: when the gold or a pit was in the last column, another underscore was printed. That bug could only be solved by writing a new line in the else clause. It also showed a problem with the way I was adding the directions to the moves list, as I was trying to add them in the tail. The problem was solved with the use of the *append/3* rule. The board with the path followed by the player is the one shown in figure 1.1.

![](https://i.imgur.com/esa72Ba.png)

**Figure 1.1.** The player reaches the gold.

The next test board was the one shown in figure 1.2, it had two pits and one Wumpus. One of the pits was specifically put in the path the player followed in the first test board in order to make sure the player did not follow the same path. It worked correctly as the player noticed the breeze, backtracked and moved to another direction, as shown in figure 1.2.

![](https://i.imgur.com/erhbd9m.png)

**Figure 1.2.** The player avoids the pit and reached the gold. 

When testing the last mentioned board, I noticed that if the gold was placed near the Wumpus or a pit, the player would not notice it and the board would be unresolvable, as the breeze and stench perceptions were checked before the glitter perception. I changed the order in the *checkCell* rule and tested it in a third test board with the Wumpus besides the gold. The problem was solved as the player was able to find the gold like shown in figure 1.3.

![enter image description here](https://i.imgur.com/HEhiOy2.png)

**Figure 1.3.** Player reached the gold when near a stench. 

When I was sure that the player was able to find the gold, avoiding the pits and the Wumpus, I introduced the possibility of killing the Wumpus when a stench was perceived. The player shoots the arrow to one direction and if the Wumpus is not there, it backtracks and repeats it to another direction, until it is killed. Once killed, the player continues to move. \
Using the third test board again, the player was able to kill the Wumpus and reach the goal without any problem, but then I found a bug caused by how I updated the fact of the Wumpus’ status: I used *retractall(wumpusAlive(_))* and *assertz(wumpusAlive(false))* to update its status to dead, but the problem was that when the program backtracked, the Wumpus was not alive again. As shown in figure 1.4, in the first solution the wumpus gets killed but in the next one, it should be alive because the player does not perceive the stench.  

![enter image description here](https://i.imgur.com/F91PWTT.png)

**Figure 1.4.** Wumpus not coming to life again in the next solution. 

The problem with Wumpus’ status was solved adding a variable that indicates its status, and as shown in figure 1.5, in the first solution the Wumpus gets killed but in the next one, it is alive again.

![enter image description here](https://i.imgur.com/Io6YqCy.png)

**Figure 1.5.** Wumpus coming back to life in the next solution.

Although the code has no bugs, it does not mean that every board has at least one solution. Pits are avoided at all costs: the player is not risky so if a breeze is found they would backtrack and find another path. So if on a map, the only way to get to the gold is crossing a breeze, that board will be unsolvable, like the ones shown in figure 1.6. 

![enter image description here](https://i.imgur.com/VRM4ZYZ.png)

**Figure 1.6.** Unsolvable boards due to the location of pits.
