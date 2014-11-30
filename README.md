# Quelab mods for the Zen ToolWorks 7x7 CNC Router

## Building Parts
### Simple Spoil Board

```sh
 openscad -o stl/spoil_board.stl -D 'file_type="stl"' src/simple_spoil_board.scad
```

### Enclosure
Inital box was created with [Box Maker for InkScape](http://wyolum.com/t-slot-boxmaker/). Then the 2d projections as dxf files were imported in Inkscape to arrange the box layout.

## Compiling and Installing Grbl

### Grbl Soft Settings
as per settings on stepper controllers: 
* MICROSTEPS 8
* STEPS_PER_REV 200.0
* MM_PER_REV 8.0 

steps_per_mm = (STEPS_PER_REV*MICROSTEPS)/MM_PER_REV
	200*8/8 = 200

```gcode
$0=10 (step pulse, usec)
$1=25 (step idle delay, msec)
$2=0 (step port invert mask:00000000)
$3=2 (dir port invert mask:00000010)
$4=0 (step enable invert, bool)
$5=0 (limit pins invert, bool)
$6=0 (probe pin invert, bool)
$10=3 (status report mask:00000011)
$11=0.020 (junction deviation, mm)
$12=0.002 (arc tolerance, mm)
$13=0 (report inches, bool)
$14=1 (auto start, bool)
$20=1 (soft limits, bool)
$21=0 (hard limits, bool)
$22=1 (homing cycle, bool)
$23=3 (homing dir invert mask:00000011)
$24=50.000 (homing feed, mm/min)
$25=2500.000 (homing seek, mm/min)
$26=250 (homing debounce, msec)
$27=1.000 (homing pull-off, mm)
$100=200.000 (x, step/mm)
$101=200.000 (y, step/mm)
$102=200.000 (z, step/mm)
$110=5000.000 (x max rate, mm/min)
$111=5000.000 (y max rate, mm/min)
$112=1000.000 (z max rate, mm/min)
$120=500.000 (x accel, mm/sec^2)
$121=500.000 (y accel, mm/sec^2)
$122=200.000 (z accel, mm/sec^2)
$130=145.000 (x max travel, mm)
$131=120.000 (y max travel, mm)
$132=200.000 (z max travel, mm)
```

## CAM
```
$G
[G1 G54 G17 G21 G91 G94 M0 M5 M9 T0 F50.]
```
# Grbl Defaults
```
[G0 G54 G17 G21 G90 G94 M0 M5 M9 T0 F0.]
```

## Grbl Defaults and their meaning:
These descriptions were taken from [LinuxCNC G-code ref](http://linuxcnc.org/docs/html/gcode.html)
### G1  - Coordinated motion ("Straight feed")

### G54 - Select Coordinate System 1
This is a fixed position saved from restart to restart. It is used as a zero position for a part. So if there is a fixture
that you want to start from use this. This is related to G92 (change the current coordinate system to the current tool position). 

[Description of Work Coordinate System for Grbl](http://www.shapeoko.com/wiki/index.php/G-Code#Using_the_Work_Coordinate_Systems)

### G17 Select the XY Plane
Which plane arcs movement is calculated on?

### G21 Movements in Millimeters

### G90 Absolute Distance Mode
All movements are relative to the Coordinate System instead of relative to the end point of the previous move (G91). Use (G92 X0 Y0 Z0) for movement relative to a temporary zero start position.

### G94 Feed Rate Mode
Units per Minute Mode. In units per minute feed mode, an F word is interpreted to mean the controlled point should move at a certain number of inches per minute, millimeters per minute, or degrees per minute, depending upon what length units are being used and which axis or axes are moving.

### M0 Program Pause
Related to Cycle Start which is set to Auto by default for grbl. This state essentially has no effect unless disabling auto start mode.

### M5 Stop the Spindle
M3 will start the Spindle unless (S0). Set Spindle speed up to S12000 to turn the spindle on.

### M9 Turn off all Coolant
Not important because the spindle used on the ZTW is air cooled when in operation. 

### T0
### F0. Feed Rate set to 0

## MakerCam notes
By default MakerCam seems to add the following to the beginning of the G-code File:

G21 G92 G40
* G21 millimeters
* G90 Absolute Machine Positioning
* G40 Tool radius comp off [Not Supported by Grbl](http://www.shapeoko.com/wiki/index.php/G-Code#G-code_Not_supported_by_Grbl)

MakerCam also appears to give absolute positions

## MeshCam Notes
By default MeshCam adds the following: G21 G91
* G21 mm
* G91 Movements relative from First fixture location


## [OpenSCAM](http://openscam.com/download.html)

## [Inkscape + GcodeTools](https://github.com/cnc-club/gcodetools)
