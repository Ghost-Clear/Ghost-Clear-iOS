# Ghosting Connector

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/f432739c87a440028ba7306384e9e197)](https://www.codacy.com/manual/varunchitturi/Ghosting-Connector?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=varunchitturi/Ghosting-Connector&amp;utm_campaign=Badge_Grade) [![CodeFactor](https://www.codefactor.io/repository/github/varunchitturi/ghosting-connector/badge)](https://www.codefactor.io/repository/github/varunchitturi/ghosting-connector) [![Actions Status](https://github.com/varunchitturi/Ghosting-Connector/workflows/Build/badge.svg)](https://github.com/varunchitturi/Ghosting-Connector/actions)

## The official source code of the Ghost Connect App

The ghost connect app is an app for squash that connects to up to 6 devices to help a player ghost and enhance game quality.

## Ghosting Device

For the repository for the ghosting devices, refer to https://github.com/varunchitturi/Ghosting-Device

## File descriptions

### LaunchViewController.swift

![](https://media.giphy.com/media/cO8tGpOdflt6Y203M5/giphy.gif)

This file controls the view controller that hosts the launch screen icon and decides whether to go to the home page or allow the user to to log in.

### InitialPageViewController.swift

![](https://media.giphy.com/media/Wn6kCNRfWmo4P5SwRb/giphy.gif)

This file controls the view controller that opens only if it is the user's first time logging in.
To check, if it is the user's first time logging in, a Core Data entity is used.
Here the user can enter their name which is then saved in Core Data for future use.

### InitialMainViewGoalsViewController.swift

![](https://media.giphy.com/media/gfHBfs7amypiMtqvBx/giphy.gif)

This file controls the view controller that shows a table view of created goals.
It has a finish button that takes the user to the home page and an add button that allows the user to add goals.
The user can tap on a goal to view its details

### InitialAddGoalViewController.swift

![](https://media.giphy.com/media/S3o3PCVeXJ2PAVa0nO/giphy.gif)

This file controls the view controller that allows the user to add a single goal.

### InitialEditGoalViewController.swift

![](https://media.giphy.com/media/Kxi13GOSTXOKl0g2e2/giphy.gif)

This file controls the view controller that allows the user to edit a goal that they have made.

### InitialViewGoalViewController.swift

![](https://media.giphy.com/media/fYTn8mxrtaTqLLHljH/giphy.gif)

This file controls the view controller that shows a created goal to user.

### HomePageViewController.swift

![](https://media.giphy.com/media/XzkF7f3tBJOWBpN2Bx/giphy.gif)

This file controls the view controller that contains the home page.
The main use of this file is to populate the workouts this week chart.
All the other buttons are connected to other view controllers by storyboard segues.

### HomeMainViewGoalsViewController.swift

![](https://media.giphy.com/media/hpd97DspU74198mKV1/giphy.gif)

This file controls the view controller that shows a table view of the user's created goals.
Goals appear read if they have not been completed and green if they have.
The user can tap on a goal to view its details.

### HomeAddGoalViewController.swift

![](https://media.giphy.com/media/RlxeY2od4b5ud70pbv/giphy.gif)

This file controls the view controller that allows the user to add a goal.

### HomeEditGoalViewController.swift

![](https://media.giphy.com/media/QYdgxZgTHwtOYxcBFi/giphy.gif)

This file controls the view controller that allows the user to edit a goal they have created.

### HomeViewGoalViewController.swift

![](https://media.giphy.com/media/j72BBkDCpJYsA4e41Z/giphy.gif)

This file controls the view controller that allows the user the view the details of a goal they have created.

### HomeMainViewWorkoutsViewController.swift

![](https://media.giphy.com/media/TEu2XPhAOgUz7gjfHB/giphy.gif)

This file controls the view controller that shows a table view of the workouts they have created.
Each table view cell has an icon that represents what type of workout it is and a short description of the workout.
The user can tap on a workout to view more detail about it.

### HomeViewWorkoutViewController.swift

![](https://media.giphy.com/media/U8HO2iN77q8ro3mtJd/giphy.gif)

This file controls the view controller that shows the details of a workout completed by the user.

### HomeViewBeepTestWorkoutViewController.swift

![](https://media.giphy.com/media/kyWT0fxUks6hLOJlyT/giphy.gif)

A file that controls the view controller that displays information about a finished beep test workout.
This is file is a variation of the HomeViewWorkoutViewController.swift which supports all the attributes of beep test.

### ChooseNumberWorkoutAttributesViewController.swift

![](https://media.giphy.com/media/cMKvCoDZPNSO9H8Pst/giphy.gif)

This file controls the view controller that allows the user to choose the details of their workout.

### ChooseNumberWorkoutPatternViewController.swift

![](https://media.giphy.com/media/f9Rmxz3YygGMzN2y5g/giphy.gif)

This file controls the view controller that allows the user to choose which corners they want to ghost to.
To load the image of their current selection - 64 images are used to represent all possible combinations of their choice.
To load the image, the images are named in binary representing true or false of a picked corner.
The binary image is named : isBackRight(LR) - isBackLeft(LL) - isCenterRight(CR) - isCenterLeft(CL) - isFrontRight(FR) - isFrontLeft(FL).
The boolean values are concatenated in the above order as boolean integers and represented as one single string. Example - "100100".

### NumberWorkoutConnectionProgressViewController.swift

This file controls a pop up view controller that shows a small pop up window of the connection progress to the ghosting devices.

### DoNumberWorkoutViewController.swift

![](https://media.giphy.com/media/J3RN8m0Un11qExID8C/giphy.gif)

This file controls the view controller that the user will see when they do the number workout. 
Most of the code in this file is to connect to the 6 peripherals.
The app uses the detection message received from the peripheral and write values to do the workout.
The app receives using the rx characteristic and sends using the tx characteristic.

### NumberWorkoutCheckPopupViewController.swift

This file controls a pop up view controller that shows a check mark when the workout is finished.

### DoneNumberWorkoutViewController.swift

![](https://media.giphy.com/media/XzvgleBxm653gJv7r9/giphy.gif)

This file controls the view controller that shows the details of a recently finished workout.

### ChooseTimedWorkoutAttributesViewController.swift

![](https://media.giphy.com/media/LOFNMZGhpuiF3BTwOE/giphy.gif)

This file controls the view controller that allows the user to choose the details of their workout.

### ChooseTimedWorkoutPatternViewController.swift

![](https://media.giphy.com/media/VeGit12NaNu8b2Avye/giphy.gif)

This file controls the view controller that allows the user to choose which corners they want to ghost to.
To load the image of their current selection - 64 images are used to represent all possible combinations of their choice.
To load the image, the images are named in binary representing true or false of a picked corner.
The binary image is named : isBackRight(LR) - isBackLeft(LL) - isCenterRight(CR) - isCenterLeft(CL) - isFrontRight(FR) - isFrontLeft(FL).
The boolean values are concatenated in the above order as boolean integers and represented as one single string. Example - "100100".

### TimedWorkoutConnectionProgressViewControllerViewController.swift

This file controls a pop up view controller that shows a small pop up window of the connection progress to the ghosting devices.

### DoTimedWorkoutViewController.swift

![](https://media.giphy.com/media/S46BCDiujkAH1aSUEP/giphy.gif)

This file controls the view controller that user will see when they do the number workout. 
Most of the code in this file is to connect to the 6 peripherals.
The app uses the detection message received from the peripheral and write values to do the workout.
The app receives using the rx characteristic and sends using the tx characteristic.

### TimedWorkoutCheckPopUpViewController.swift

This file controls a pop up view controller that shows a check mark when the workout is finished.

### DoneTimedWorkoutViewController.swift

![](https://media.giphy.com/media/KZdyT6E6yAL9wWqLJM/giphy.gif)

This file controls the view controller that shows the details of a recently finished workout.

### MainChooseMatchViewController.swift

![](https://media.giphy.com/media/d8XGzW539UKulK0A7R/giphy.gif)

This file controls the view controller that contains a table view of a ll the matches that can be simulated.

### ChooseProWorkoutAttributesViewController.swift

![](https://media.giphy.com/media/gL3UZBdoxivSOm6faD/giphy.gif)

This file controls the view controller that allows the user to pick the details of a match that will be simulated.

### DoProWorkoutViewController.swift

![](https://media.giphy.com/media/XDRa1RzpPEaKsbLd97/giphy.gif)

This file controls the view controller that shows the details of a pro workout in progress.

### ProWorkoutConnectionProgressViewController.swift

![](https://media.giphy.com/media/dyYDfS1Gat2ne5g0rG/giphy.gif)

This file controls the pop up view controller that shows the connection progress for the phone to the devices

### DoneProWorkoutViewController.swift

![](https://media.giphy.com/media/QAnQlEDjjtaE8MWjo1/giphy.gif)

This file controls the view controller that shows the details of a recently finished pro workout.

### ProWorkoutCheckPopupViewController

![](https://media.giphy.com/media/SSVTmgTsSDJ5SYaWfg/giphy.gif)

This file controls the pop-up view controller that shows an animated check mark when a pro workout is finished.

### SettingsViewController.swift

![](https://media.giphy.com/media/VeBIJ60zvzhQalO5Px/giphy.gif)

This file controls the view controller that shows the settings menu.

### BluetoothGuideViewController.swift

![](https://media.giphy.com/media/UVBVqtutSsC3c4XfON/giphy.gif)

This file controls the view controller that allows the user to erase all bluetooth data.

### ChangeNameViewController.swift 

![](https://media.giphy.com/media/WtPd980KJhopWbN1LS/giphy.gif)

This file controls the view controller that allows the user to change their name.

### ChangePreparationTimeViewController.swift

![](https://media.giphy.com/media/ZCSy9yK3D0TQtGNe06/giphy.gif)

This file controls the view controller that allows the user to change the preparation time before the start of a workout.

### BeepTestWorkoutDescriptionViewController.swift

![](https://media.giphy.com/media/SwxlixzqP24Rd06O6D/giphy.gif)

This file controls the view controller that has descriptions about the beep test.

### BeepTestWorkoutCheckPopupViewController.swift

![](https://media.giphy.com/media/hT6BOeEMd9B67rusk9/giphy.gif)

This file controls the pop up view controller that shows a check when the beep test workout.

### BeepTestWorkoutConnectionProgressViewController.swift

![](https://media.giphy.com/media/PlsxmA86cSuZm8ejuT/giphy.gif)

This file controls the view controller that shows a status check to see if the app has connected to necessary devices.

### DoneBeepTestWorkoutViewController.swift

![](https://media.giphy.com/media/ehs4jazSAfoyY27avC/giphy.gif)

This file controls the view controller that shows the details of a recently finished workout.

### DoBeepTestWorkoutViewController.swift

![](https://media.giphy.com/media/mEgVE6sBbUlQojQkEw/giphy.gif)

This file controls the view controller that does the beep test workout.

### WorkoutButtonsPageViewController.swift

![](https://media.giphy.com/media/kaUDEDUgng8FXaEWwS/giphy.gif)

This file controls the page view controller that contains a page view of all the workout buttons.

### FirstButtonSetViewController.swift

This file controls the view controller that displays the start timed workout button and the start number workout button.

### SecondButtonSetViewController.swift

This file controls the view controller that displays the start beep test button.

### HomeChartPageViewController.swift

![](https://media.giphy.com/media/Pllw0i2NjJHc4a0NOc/giphy.gif)

This file controls the page view controller that shows the workouts this week chart and the beep test progress chart.

### WorkoutCompositionGraphViewController.swift

![](https://media.giphy.com/media/hvReX7NIB3TWELM9UN/giphy.gif)

This file controls the view controller that contains a circular workout composition chart to show a pie chart of each type of workout done.

### PlayerStatsViewController.swift

![](https://media.giphy.com/media/Qa46TnMsXfViUlBI5k/giphy.gif)

This file controls the view controller that displays information about the overall ghosting stats of a player.

### HomeWorkoutsThisWeekViewController.swift

This file controls the view controller that contains that workouts this week chart.

### BeepTestProgressViewController.swift

This file controls the view controller that contains the beep test progress chart.

### UUIDKey.swift

This file holds all the UUID numbers for the ghosting devices.

### CircleProgressView.swift

This file is a class for a loading circle view.

## Unused Delegates

This folder contains unused table view class files which were just used to instantiate the table view controllers.
These table view controllers are located in any file with "Main" in its name.

## Libraries

This app uses cocoa pods for its libraries.
The libraries used are:

1. CocoaAsyncSocket
2. Charts - for chart on home page
3. CircleTimer - for circle timer used in workouts
4. M13Checkbox - for checkbox animation
5. TKSubmitTransition - for th animation in the initial login

## Notes

1. Peripheral name references
	1. Front Right is referred to as FR in the code
	2. Front Left is referred to as FL in the code
	3. Center Right is referred to as CR in the code
	4. Center Left is referred to as CL in the code
	5. Back Right is referred to as LR in the code
	6. Back Left is referred to as LL in the code

## Contributions

1. Make sure to include the file description in the readme if it is a new file
2. Make sure all segues are named by the "going to" view controller + "Segue"
3. Make sure all new libraries used are listed in the readme file
3. If a new view controller is added, provide a gif of it in the readme. (Use giphy to generate gif)



