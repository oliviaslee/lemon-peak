# Lemon Peak
UC Berkeley | Design Innovation 23 Final Project
------------------------------------------------

Prompt:
Using Processing and Arduino, create an interactive show/demo for Spring'19 Demo Showcase

---------

## How to play demo:
In order for the demo to cohesively compile and run, both software and hardware components are required. 
Instructions to download, edit, and run an isolated version of the demo (Processing: software component only), can be found here: [Isolated Lemon Peak Package](processing-only/README.md). 

### Prerequisite
0.1) The following software is required to run demo package properly:
   - Processing (Version 3.5.3 (3 February 2019) compatible)
      - instructions for software download can be found [here](https://processing.org/download/)
   - Arduino (Version 1.8.8 compatible)
      - instructions for software download can be found [here](https://www.arduino.cc/en/Main/Software)
      
0.2) The following hardware components are required to setup demo package properly:
   - 1 x Arduino Uno Rev3
   - 1 x TowerPro SG90 servo motor
   - 1 x Adafruit 12-Key Capacitive Touch Sensor Breakout - MPR121 
      - Minimum requirement of 6 key sensors
   - 1 x Load Cell Weight Sensor, straight bar
      - swap with another weight sensor might require change in code.
   - female to male wires, male to male wires
   
### Requisites
1. Download repository or all files within subsequent directories within this repo. 
   - Modifying any of the file or directory names can result in a compilation error.
2. Set up all hardware components to Arduino Uno and connect to machine running processing and arduino files.
   - Instructions to setup hardware can be found [here](arduino/README.md)
3. Opening up main finalProj.pde file should simultaneously open other necessary processing files. Only the one Arduino file needs to be opened. 
4. For both Processing and Arduino files, make necessary changes to port imports (modify code) and syncing of ports with  hardware to software.
   - Critical step for correct code compilation and successful communication between both hardware components and software, and processing and arduino files.
5. First **upload** Arduino file, then **upload and run** Processing file.
