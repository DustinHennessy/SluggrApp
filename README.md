# SluggrApp

This app is a ridesharing app designed to make the art of slugging, also known as carpooling, more organized and safer. The app pulls data from a custom ruby backend in order to register a user, login, pull user information and edit a profile. 

SluggrApp uses a singleton currentUserManager to handle the login of a user and the passing of the logged-in user data between view controllers.

###EditProfileViewController

The tableview on the EditProfileViewController is created dynamically using a label array and custom TableView Cells and a data field array. 

````
var dynamicLabelArray = ["First Name", "Last Name", "Home Address", "Work Address", "Morning Depart Time", "Evening Depart Time", "Driver Status","Bio", "Preferences", "Your Map"]
    
var dataFieldTypeArray = ["TextFieldCell", "TextFieldCell", "TextFieldCell", "TextFieldCell", "LabelCell", "LabelCell", "SwitchCell","TextViewCell", "TextViewCell", "MapCell"]

````
This makes adding a row or removing a row easier. It also makes this code reusable in other projects.

###Date Picker popping

In order to get the date picker to pop into the table, in didselectrowatindexpath I create a seperate indexPath and add a row to it. That way when the proper row is tapped I can use this seperate indexpath to pop the datepicker row in after it. 

```
let nextIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
```

```
dynamicLabelArray.insert("Start Time", atIndex: indexPath.row + 1)
dataFieldTypeArray.insert("DateCell", atIndex: indexPath.row + 1)
profileTableView.insertRowsAtIndexPaths([nextIndexPath], withRowAnimation: UITableViewRowAnimation.Bottom)

``` 

![image of date picker popping into the table]

(iOS Simulator Screen Shot Sep 7, 2015, 4.27.08 PM.png)

to pop the datePicker row out of the table you do essentially the same thing but you remove the row when the respective row is tapped.


###Sorting Users

Users can sort the table of users on the homescreen based off of how close users are to their current location.

```
userArray.sort { $0.userDistance < $1.userDistance }

```

I use a toggle to switch the sort UIBarButtonItem between sorting users based off of their work location or their home location. The image toggles with it between an image of a briefcase representing the user's work locations and an image of a house for their home locations.

