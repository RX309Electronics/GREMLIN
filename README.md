# Under maintennace currently!

# Introduction
You might have already read the description, but this project builds a functional, pretty fully-featured Embedded Linux distro that uses Xorg and Supports SDL. It is primarily intended to run your graphical apps that might need an os backbone. This is a hobby project and i primarily made it for my own projects so i included a lot of stuff inside of it that is/might be handy to use, but of course you can edit the configuration file and rip stuff out or add stuff in. Its based on buildroot, a build environment and toolset for building embedded linuxes, that have the stuff you select, compiled in and nothing else, unlike a traditional distro. This makes it so depending on what you select, you wont have all the bloat or overhang like a traditional GNU/Linux distro, and also no standard packagemanager or installer. This project builds a initrd, but also builds a ext2/ext4 image you can directly flash to a drive, and it builds a linux kernel of course! Its primarily intended for running python GUI Apps like with sdl or Pygame, and it has pip package manager pre-installed. On first deployment, you might need to implement some logic yourself that it downloads all dependancies and then boots the application. 

# Why the name?
I dont really know why, but the name 'GREMLIN' fit perfectly with the goal and end product. A 'GRaphical EMbedded LINux' distro. Also cause i came up with the idea in a mischievous moment, and i wanted to think of a name that described/included part of the project but also was not random letters or gibberish. 

# What do you get?
A Full working embedded linux distro with:
- Xorg and SDL
- Audio support
- Touchscreen and mouse input
- On-screen keyboard
- Python3 + Pip built in
- A Couple fun games built in to test functionality
- Networking and NTP time
- A Userland with a ton of handy and nice to have stuff
- smaller format than most typical Distro's
- possibility to run as a ramdisk
- user customisability in mind
- Customisable Services/Tasks to be run on startup (placeable in /System/Services).
- Customisable Application binaries can be run by placing them in /System/Application
- 1 App_init.sh script to start the desired application found in /System/App/
- 2 Stage Inity with logging
- Error handeling and fallback mechanisms.
- Will Automatically boot into the application (if available) with minimal, to no, user interaction required. (Deploy and forget)

# What is the boot flow?
BIOS/UEFI > Bootloader > Linux kernel > Init Stage1 (Start basic low level system services like rng, syslog, udev, klog, etc etc) > Xorg (Started in Stage1) > Init Stage2 (Load higher level services like; Network, Avahi, ntp, ssh, etc etc) > Start Window manager (matchbox) fullscreen > Start /System/App/App_init.sh > Application. 
While its starting and initialising everything, it will write a lot of logfiles to make debugging really easy. If App_init.sh fails, or the App directory or App_init.sh does not exist, it enters a developer shell. In App_init.sh, you can put all the logic to start your desired application (eg some pygame GUI or whatever project). 

# What architectures does it support?
Currently only X86_64, but i want to expand it to Arm platforms (raspberry pi and other known boards primarily) in the future somewhere. 32 bit (legacy i386/x86) is not supported, due to 32 bit suport being slowly phased out of the Linux kernel and Linux ecosystem because its not worth maintaining for such a small userbase. And many people these days have a 64 bit computer/sbc, so for me its also not worth it to implement legacy x86/i386. But if you want, you can do it yourself if you are familiar with buildroot and Linux, but you gotta fix bugs and issues yourself.  

