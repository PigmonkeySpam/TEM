# How do network messages work

A B

## Happy path
A: ping, B waiting for message <br>
B gets message - replies: pong <br>
A waiting for message - receives pong from B <br>

Iteraction complete


## Unhappy paths
- A: ping
- B --
- A: ping until timeout 
- failed
But B might then listen and time out
___
- A: ping <br>
- B - no reply 
- A: ping
- B: pong
- RESOLVED


## Complications
- A: marco
- B: ping
- *A is listening for "polo* and B is listening for "pong"
- **both will likely timeout**

Might need to work **async stuff** <br>
...or I can just be really careful <br>
There is a risk that sendUntilHeard() could stop other messages being heard. Could instead have only one listening funciton that runs contiiously. Messages to listen for and corresponding actions could then be added because Lua is werid and allows you to do stuff like that.