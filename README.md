# AR Education - 3rd Place at Menlo Hacks
#### An approach to programming education that uses augmented reality to make learning more interactive and entertaining.

# Inspiration
There are numerous games and apps out there that use a gaming framework to teach people how to code, but we feel that people often lose interest because it isn't interactive enough. So, in an attempt to more effectively grip the user, we made our core element something that somehow never gets old: augmented reality. We quickly wrote down a few quick ideas for the game flow and objectives and we began work on the morning of March 10, 2018 at MenloHacks III.

# What it does
The rules of the game are simple: one writes pseudocode for a blue robot to move through a level composed of grey walls and reach the goal, a green polygon. The bot must try to avoid red obstacles! Difficulty and complexity ramp up from the first level to facilitate the learning experience.

We also implemented a fully functional online level designer. Using a 16x16 grid, users design a level of walls, obstacles, a goal, and a player spawn. When they compile it by hitting the green "compile" button, a QR code appears on the screen. This is scanned in the app to open the level in the game. Share your levels with your friends!

Finally, we made an effort to complete a fully functional competitive multiplayer AR mode in which both players compete to collect the most goals in a large grid in a limited amount of time. While we weren't able to fully polish and manage total functionality with this feature, we have a prototype that shows synchronized player updates on both screens. Players are connected using a unique four-digit game code.

# How we built it
The iOS app was built in XCode and used an augmented reality library called ARKit. The web app was made using Foundation with jQuery and was designed by hand using SublimeText in HTML and CSS. The 3D models used in game were designed with Autodesk Maya to be imported into ARKit. All of these parts came together in our current draft of Droid Control.

# Challenges we ran into
Our biggest challenge with this project(as it is with every group project) was maintaining a synchronized and organized Git repository that we could all push and pull to as we needed. Of course, throughout managing all of these subcomponents that made up our project, we erred in keeping ourselves organized and updated, leading to many merge errors and lost work.

In addition, it was a challenge learning two new systems: QR code scanning and augmented reality. All of us were new to these concepts and managed to successfully implement them in a timely manner.

# Accomplishments that we're proud of
We are very proud of our fully functional web app that allows easy uploads of custom levels to Droid Control. In addition, we are proud of the simplistic design choices we made in modeling our game that, while sacrificing realism, maintains a satisfying aesthetic and efficient performance.

# What we learned
Everyone on our team got a chance to polish up our Swift programming skills by designing this app. In addition, we learned a lot about how, if work is divided up fairly according to peoples strengths and every team member is willing to put in the hard work and elbow grease to finish their work and then some, you can impress even yourself with your accomplishments in a short period of time.

# What's next for Droid Control
We plan to continue development for Droid Control over the coming weeks to really work out the kinks with some of our graphics along with completing the requirements necessary for fully functional multiplayer. We also hope to make a few UI changes to help the design flow as intuitively as possible.

# Built With
`swift`, `html`, `css`, `foundationdb`, `arkit`, `firebase`, `xcode`

# Try it out
[droidcontrol.github.io](droidcontrol.github.io)
