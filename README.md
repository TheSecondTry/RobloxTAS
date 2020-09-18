# RobloxTAS
A script I made to (hopefully) give TASing tools to Roblox games.

## What is a TAS?
A TAS, or Tool-Assisted Speedrun/Superplay, is a run of the game that uses tools like slowdown and savestates to either create an entertaining gameplay video or to create a "perfect" speedrun.
These links should explain everything about TASing.
- [How to create the perfect speedrun - Tool-assisted speedrunning explained](https://www.youtube.com/watch?v=Ietk1-Wb7oY)
- [Introduction to TAS: Tool-Assisted Speedrunning (What, How, Why?)](https://www.youtube.com/watch?v=R3-ohYvi_fc)
- [TASVideos / Welcome to TAS Videos](http://tasvideos.org/WelcomeToTASVideos.html)

## How does this system work?
This system simply saves all states of the game and plays them back, unlike what TASing emulators/programs (e.g. Mupen64, BizHawk, libTAS) normally do, which is record sequences of controller inputs and feeding those inputs into the game when playing the movie file back.
The savestate feature saves the [CFrames](https://developer.roblox.com/en-us/api-reference/datatype/CFrame) for all of your character's body parts, as well as the camera CFrame and your character's velocity.
The slowdown feature works by anchoring and unanchoring the character's body parts, creating the effect of the game being slowed down or paused.

You can try out the system [here](https://web.roblox.com/games/5600348126/Roblox-TAS-Test).
You can also see this system in action [here](https://www.youtube.com/watch?v=Qvp_G08hlvA).

## How do I use this system?
Adding the system to a Roblox game is simple.
First, go to the [Releases page](https://github.com/luigidasonic/RobloxTAS/releases) and download the RBXM files.
Next, open the game you want to TAS in Roblox Studio.
In the "Explorer" tab, go to the StarterPlayer folder and insert the RBXM file for the TAS script into StarterPlayerScripts by right-clicking and selecting "Insert from File".
**If using the first version of this script, insert the RBXM file for the TASing script into StarterCharacterScripts.**

Now you can begin TASing the game you chose.
You can start the game by clicking the "Play" button in the top menu.
**NOTE: This system only works with R6 characters and does not support R15 characters. You'll have to go to "Game Settings" and under the "Avatar" tab, set the Avatar Type to R6.**

Once you start playing, you may notice that the game is in a "paused" state.
If you press the backslash ( \ ) key, the game will advance by one frame.
In order to unpause the game, press the F key.
If you don't want the game to be slowed down, press the E key.

**NOTE: If you either unpause the game or disable slowdown while the game is paused, you'll have to press the frame advance key after doing so.**

If you want to use savestates, press the Y button to save the current state of the game and H to load the saved state.

## I'm done making my TAS! How do I play it back?
Once you're done making your TAS, press the comma ( , ) key to play it back.
**NOTE: If you're using frame advance, press the frame advance key while holding down the comma key. If using slowdown, keep pressing the comma key until it plays back.**

## When playing back my TAS, the animations are sped up. Why does this happen and how can I fix it?
This happens because when the game is being slowed down or paused, it's not actually slowed down or paused. What's actually happening is that your Roblox character's body parts are being anchored, in order to create the effect of the game being slowed down. However, Roblox animations still play even when a Roblox character's body parts are being anchored.

However, I have made a modified version of Roblox's Animation script which pauses the animations when your character's body parts are anchored. You can download the RBXM file for that script and put it in StarterCharacterScripts.

## I don't like the default hotkeys. Can I change them?
Yes, it is possible to change your hotkeys.
In order to do this, expand the TAS script in the "Explorer" tab, then expand the Settings folder. You should see a folder in there named Hotkeys. Expand that and you'll see all the hotkeys that the script uses.
Select the one you want to change, then in the "Properties" tab, set the value to the key you want to use.
You'll need to set the value to the "key code" for the key you want.
You can get it by either looking at [this page](https://developer.roblox.com/en-us/api-reference/enum/KeyCode) or by adding a new script into StarterCharacterScripts and adding this code into it:
```
game:GetService("UserInputService").InputBegan:connect(function(input)
print(input.KeyCode.Name)
end)
```
After adding the script, start up the game and open up either [the output window](https://developer.roblox.com/en-us/articles/Debugging#output-window) or [the developer console](https://developer.roblox.com/en-us/articles/Developer-Console).
Once the game is running and either the output or developer console is open, press the key you want and you'll see the key code there.

**NOTE: There are lots of settings that you can change in the Settings folder, so feel free to change some.**

## What is the "GameWatch.lua" file for?
"GameWatch.lua" is the watching program I've developed. It gives you useful information about your character that you can use to your advantage.

To use it, download the script.
Next, open the script in a **plain-text editor** such as Notepad (Windows) or GEdit (Ubuntu/Linux), or in a **code editor** such as Notepad++ (Windows), TextWrangler (MacOS), Atom, or Visual Studio Code.
Change the value of "playerName" in line 2 to your Roblox username. Otherwise, it won't work.
Then, in Studio, select the Plugins tab, click "Plugins Folder", and put the script in the folder.
Now, right click on the top of any open window in Studio, and make sure Game Watch is open.
