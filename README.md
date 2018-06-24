# MinGW Distro: [nuwen.net/mingw.html](https://nuwen.net/mingw.html)

Here are the build scripts for my MinGW distro.

You'll need to run them in MSYS2, which you can set up without an installer:

* Go to: https://sourceforge.net/projects/msys2/files/Base/x86_64/
* Download: `msys2-base-x86_64-20180531.tar.xz`
* Extract it to: `C:\Temp\gcc\msys64`
* Run: `msys2_shell.cmd`
* RECYCLE MSYS2, which means:
  * Close MSYS2 by clicking the window's red X. (Don't type `exit`.)
  * In Task Manager, terminate `pacman.exe` if it's still running. (Sometimes it will, sometimes it won't.)
  * Restart MSYS2.
* In MSYS2, run: `pacman -Syuu`
* RECYCLE MSYS2.
* Repeat the previous two steps until you see this:
```
$ pacman -Syuu
:: Synchronizing package databases...
 mingw32 is up to date
 mingw64 is up to date
 msys is up to date
:: Starting core system upgrade...
 there is nothing to do
:: Starting full system upgrade...
 there is nothing to do
```
* In MSYS2, run: `pacman -Su cmake diffutils make nasm patch tar texinfo`
* RECYCLE MSYS2.

### Important Notes

The build scripts assume that they can use `C:\Temp\gcc` as a working directory and that they do not live directly within it.
They also assume that they live next to the sources. I generally put both of them into `C:\Temp\gcc\sources-VERSION` .

I **highly** recommend that you execute each build script **by hand** before attempting to run it in one shot.

Stephan T. Lavavej - stl@nuwen.net
