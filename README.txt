Micronodes for Minetest [micronode]
===================================

Minetest version: 0.4.9-dev (requires #1b5b6fe & #c9b6420)
Depends: default

Adds miniature node-like objects, for fun and decoration.
Micronodes can be placed on any pointed node or other micronode face,
they will automatically snap to the closest grid position.
Just like ordinary nodes, use right-click to place and left-click to dig.

This mod is probably best suited to creative mode, however an optional
micronode cutting laser has been added for those wishing to use this in
a survival game.

Configuration
=============

Micronode can be configured by including a file called micronode.conf in
the micronode directory. 

See https://github.com/stujones11/micronode/blob/master/micronode.conf.example
for all available config options.

Crafting
========

Micronode Cutting Laser [micronode:laser]

B = Bronze Block [default:bronzeblock]
M = Mese Crystal [default:mese_crystal]
G = Glass [default:glass]

+---+---+---+
|   | B |   |
+---+---+---+
|   | M |   |
+---+---+---+
|   | G |   |
+---+---+---+

Issues
======

Servers can get upset if they find too many active objects in one place
and may randomly remove stuff. If you have problems then try increasing
max_objects_per_block in minetest.conf

