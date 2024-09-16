# My Journey Making a 3D Game Engine
Alternatively titled "The process of realizing I'm making an engine instead of a game."

All art shown is created by me and all videos, gifs, and images are created by me using the Tuff game engine.

When I first started making a game in 2020, I barely knew any C. All I had done up to that point was write an x86 bootloader in assembly, naively attempt to do recreate Garrys's Mod in Unity using C# and play around with making some command line C programs.

---
### FoxandBox
My first early dive into game and engine development was heavily influenced by Stardew Valley and the Pokemon games. Everything from the tile based level to the art style. The name came from the main character being a fox and the game being a sandbox (such creativity!).

![](Images/particleSystem.gif)

I started off using just SDL2 and learned everything from [Lazy Foo's tutorials](https://lazyfoo.net/tutorials/SDL/)
My language of choice was C and that has remained. This is - logically speaking - a somewhat odd choice but its just personal preference for the simplicity and control I have with C. I could just as easily have done all of this in something more suitable like C++ *but wheres the fun in that?*

![](Images/speed.gif)

The first thing I did was create the world of the game. This was initially a finite square grid of fixed size which I later expanded to a chunked system for near infinite world sizes.

After level creation and movement was in a usable state, I worked on level interaction and automatic calculation of the borders between tile types. I did these calculations using a method similar to a cellular automaton. Each configuration of the 8 neighbours of a tile is assigned an index into the tile map below. This later proved to not work too well for intersections of more than 2 materials, but for 2 materials the effect is quite nice.
![](Images/autotile_mask.png)
![](Images/fasterEditing.gif)

I took a crack at developing an immediate mode* (as opposed to a retained mode**) user interface library from scratch for this project which I used for the inventory and menus. Designing a good UI library is hard.. You'll see this theme come up a couple times again when I talk about my 3D engine as well. The UI of this game was very bare bones and crude but it worked well enough for my uses.
\* An immediate mode UI is one which is updated and drawn every frame
\** A retained mode UI is a set of states and objects which store the elements of the UI. This allows for positions to be computed a single time and used over many frames if nothing changes.

![](Images/pause.mp4)
![](Images/checkbox.mp4)

I then used this UI system to make a cute little inventory system which served absolutely no purpose. Well, it would've served a purpose if i'd had any planning for the direction the game should've taken. But, alas, I had no idea what I was doing. 

![](Images/itemDrop.mp4)
![](Images/groundItems.gif)

This project was ended when I attempted to expand the game to support a fully procedurally generated map. By this point the code base was a mess and memory leaks were popping up like a game of whack-a-mole (I got pretty far considering this was my first project of this scale).

Although this game never ended up coming to anything, it taught me an incredible amount about basic programming, C, and engine development. This game is the catalyst which later drove me to make a 3D game engine. I deem this project a success. Even though there was no end goal to begin with, it was a necessary stepping stone.

---
### Tuff - The first attempt

Insert why switch to openGL 

Originally, the only reason i wanted to switch to opengl was so I could rotate sprites (which sdl2 can't do), This temptation along with all the other possibilities I saw OpenGL could bring made me eventually bite the bullet and switch over. Very quickly after achieving my goal of rotating sprites I wanted to see what else I could do with OpenGL; I didn't know it then but this would be the end of FoxandBox.

![](Images/opengl_renderer.gif)
![](Images/slider.gif)

I used the wonderfully well made site [LearnOpenGL](https://learnopengl.com/) by Joey de Vries to start learning basic 3D rendering. Once I'd gotten a fairly loose grasp on using OpenGL and toyed around with writing some shaders, I had a realization. I no longer wanted to make a game, I wanted to make a game engine.

By this point I had a comfortable grasp of *most* of C and abided by a fair amount of good coding practices - or so I thought. I went through and worked my way through the tutorial series. Starting off with .obj 3D model parsing / loading. Doing this early on helped immensely with mentally mapping from a 3D object and its triangles to the vertex data the GPU takes in.

![](Images/crate.mp4)

I followed the tutorials up to the point of basic specular lighting and then toyed around with some different models and normal / bump maps.

![](Images/more_lighting.mp4)
![](Images/shiny.mp4)

I then polished up the look of everything - taking some notes from Blender's UI - and spent a while messing around with shaders to get the overall program into a more presentable package.

![](Images/game_engine.mp4)
![](Images/pretty.mp4)

Now comes the second attempt at a UI library. This time I went with a retained mode UI and modeled it after a combination of html and css. I used [JSMN](https://github.com/zserge/jsmn) to tokenize JSON files and then parsed the contents from there. UI files contained a style section for element classes and a hierarchical scene section for the elements themselves. Classes can be applied to elements when loaded from a file and classes can be applied to elements upon hovering or clicking.

![](Images/ui_menu.mp4)

A goal of mine at this point was to make every resource (models, textures, shaders) easily hot re-loadable. This included UI and I managed to get it to a point where it was usable enough to drastically speed up UI prototyping.

![](Images/ui_colours.mp4)

This second attempt at a UI system worked great. But alas, eventually my ignorance of memory leaks caught up to me and impossible to track down bugs started popping up. 

![](Images/sentient_ui.mp4)

If I wanted to have a usable program with hot reloading and no memory leaks, I needed to change up my approach. So I started to modularize as much as I could; I wrote completely independent libraries for each part of the engine (e.g. mesh loading, shader processing, ui layout, etc). The intention was to write and test each module by itself and then combine them all into the final engine.

I think this approach ended up being the most flexible for me, as well as being incredibly easy to scale. As long as I kept the interface between modules the same, I could completely overhaul individual modules and no other piece of code would be affected. One downside is that it takes slightly more initial planning to make sure interfaces are fully fleshed out from the beginning, since any changes to the interface will affect other modules.

This modular approach also makes visualizing the dependencies between modules easier, since all dependencies are `#include`-ed at the top of each file.

I've also started to use this approach with embedded systems programming projects I'm doing. For example, I now have individual libraries for each peripheral (UART, IR comms, I2C).

---
With the most recent attempt at a UI I started off by focusing on the functionality of laying out elements before even thinking about visual things like radiused corners or the parsing and serializing aspects. This meant I ended up splitting the UI module into multiple sub-modules which can each work almost independently as well.

I used pretty much the same file format for UI files as with the previous attempt.

![](Images/particle_sim.mp4)

To showcase this version as well as the engine itself, I made a molecular dynamics simulation program which displays a 3D rendering of molecules as physical simulation of atomic collisions is carried out.

![](Images/octane_sim.mp4)

The intention with this program being to one day be able to simulate protein folding and render it in real time. But I'm in slightly over my head with this; So I chose to limit the scope and simulate only smaller simpler molecules for now.

And that is the present state of the engine.. Obviously i'm not planning on stopping development any time soon but its been going much slower because of university. As for what's next for the engine, well I'm not quite sure yet; I have a few projects i would like to try out with the engine as a base, here's a few of them listed below.

- A semiconductor analog IC design tool (similar to [Magic VLSI](http://opencircuitdesign.com/magic/)) with the following features:
	- 3D render of the deposited semiconductor with thin-film interference colours
	- Ability to export layers as masks for fabrication
	- Analog electrical and electromagnetic simulation of design
- An atomic crystal structure viewer
	- Possibly with the ability to atomically simulate semiconductors
- A "real time" protein folding simulator
	- Could play back a completed simulation rather than being real time
- Supplementary applications for the game engine itself
	- UI editor / creator
	- 3D model editor
	- Resource compiler (to compress assets and store them in a less easily modifiable form)

All of these aren't necessarily going to happen they're just cool things that I think could be fun to try to implement and would teach me a great deal about areas of science I'm interested in.

I also plan on adding scripting functionality to the engine. I have already toyed around with using Lua as well as using the [Tiny C Compiler (TCC)](https://bellard.org/tcc/) to just in time compile C code as a weird form of scripting.