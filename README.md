# ffmpeg-bash-god

Hello! ffmpeg-bash-god is a collection of scripts to record your screen (this is mostly not useful for people with a good PC, however, there are people in the world who have a somewhat limited PC). So I'm bringing you something frankly easy and very lightweight.

## Installation

The only thing you have to do is clone the repository:
```bash
git clone git@github.com:DumbNoxx/ffmpeg-bash-god.git`
```
Next, you just need to navigate to the folder and run this:

```bash
./ffmcap.sh
```

And you’re all set!!

## Usage
Once you have executed `./ffmcap.sh,` you can simply use the command ffmcap, and it will start the screen recorder. All you need to do is follow the instructions, and you’ll be ready to record your screen!!!

## Warnings
In some cases, `/ffmcap.sh` might not execute properly, so you might have to do it manually. What do I mean?

You may need to create the alias manually and give execution permissions. If you have no idea how to do it, don't worry, I'll help you with that.

## Manual Installation
Fist, clone the repository:

```bash
git clone git@github.com:DumbNoxx/ffmpeg-bash-god.git
```
Next, navigate to the folder where the .sh file is located. So far, everything is the same as at the beginning, but here things change.

When you reach the destination folder, instead of using `./ffmcap.sh`, we will do it manually:

```bash
echo alias ffmcap="absolute_path_to_your_file/ffmcap.sh" >> ~/.bashrc
```
After doing that, you will have the alias in your commands, but it's not activated yet. You need to activate it.

```bash
chmod +x ffmcap.sh```

First, give execution permissions to the file. After doing that...
```bash
source ~/.bashrc```

Or simply close and open the terminal again to reload the commands.

And you will be ready to execute the command ffmcap, allowing you to record your screen with ease.

Suggestions for Possible Errors
It is possible that when executing `./ffmcap.sh`, the command does not activate directly. My recommendation would be to use `chmod` and activate the command using `source` or by restarting the terminal to rule out any doubts about a failure.

## Final
Honestly, this is a bit silly, but I thought I would do it for people who are just starting out and may not have a powerful PC to record their screen, or who want to save resources. This is truly useful, and of course, I will continue to improve this tool. I aim to make it compatible with Mac, and perhaps I will create a simplified version for Windows.

I hope you liked it, and please give the repo a star if it helped you. Cheers!
