# plan
An open computers computer somewhere can interface with the RS system (mr_chungus), pull the stock amount. 
    - Decides if the grinder needs to be turned on or off. 
    - *Ignore if no state change*
    - Will send API requst to update grinder status
    - also pulse redstone to ComputerCraft computers

ComputerCraft computers - each control one mob node 
- wait for redstone pulse
- send get request to see if status has been updated
- update redstone output to reflect


## On states
- always on
- always off
- automatic on low stock
- also timer?