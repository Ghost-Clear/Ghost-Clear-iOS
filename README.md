# Ghosting Connector

## The official source code of the Ghost Connect App

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/f432739c87a440028ba7306384e9e197)](https://www.codacy.com/manual/varunchitturi/Ghosting-Connector?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=varunchitturi/Ghosting-Connector&amp;utm_campaign=Badge_Grade) [![CodeFactor](https://www.codefactor.io/repository/github/varunchitturi/ghosting-connector/badge)](https://www.codefactor.io/repository/github/varunchitturi/ghosting-connector) 


The ghost connect app is an app for squash that connects to up to 6 devices to help a player ghost and enhance game quality.

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

### ChooseNumberWorkoutAttributesViewController.swift

![](https://media.giphy.com/media/cMKvCoDZPNSO9H8Pst/giphy.gif)

This file controls the view controller that allows the user to choose the details of their workout.

### ChooseNumberWorkoutPatternViewController.swift

![](https://media.giphy.com/media/f9Rmxz3YygGMzN2y5g/giphy.gif)

This file controls the view controller that allows the user to choose which corners they want to ghost to.
To load the image of their current selection - 64 images are used to represent all possible combination of their choice.
To load the image, the images are named in binary representing true or false of a picked corner.
The binary image is named : isBackRight(LR) - isBackLeft(LL) - isCenterRight(CR) - isCenterLeft(CL) - isFrontRight(FR) - isFrontLeft(FL).
The boolean values are concatenated in the above order as boolean integer and represented as one single string. Example - "100100".

### NumberWorkoutConnectionProgressViewController.swift

This file controls a pop up view controller that shows a small pop up window of the connection progress to the ghosting devices.

### DoNumberWorkoutViewController.swift

![](https://media.giphy.com/media/J3RN8m0Un11qExID8C/giphy.gif)

This file controls the view controller that user will see when they do the number workout. 
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
To load the image of their current selection - 64 images are used to represent all possible combination of their choice.
To load the image, the images are named in binary representing true or false of a picked corner.
The binary image is named : isBackRight(LR) - isBackLeft(LL) - isCenterRight(CR) - isCenterLeft(CL) - isFrontRight(FR) - isFrontLeft(FL).
The boolean values are concatenated in the above order as boolean integer and represented as one single string. Example - "100100".

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
