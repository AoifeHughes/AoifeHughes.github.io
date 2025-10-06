World Generation
================

Learn how to customize procedural world generation in MMO Simulator.

Basic World Creation
--------------------

.. code-block:: python

   from simulation_framework.src.core.world import World

   # Create world with default settings
   world = World(width=60, height=60, seed=42)

Terrain Types
-------------

The world contains five terrain types:

- **Water**: Blue, impassable, fishable
- **Grass**: Green, passable, forageable
- **Forest**: Dark green, passable, has trees, forageable
- **Mountain**: Gray, impassable, mineable
- **Desert**: Yellow, passable, sparse resources

Procedural Generation
---------------------

Uses Perlin noise for realistic terrain distribution:

.. code-block:: python

   # Same seed = identical world
   world1 = World(width=60, height=60, seed=42)
   world2 = World(width=60, height=60, seed=42)
   # world1 and world2 are identical

   # Different seed = different world
   world3 = World(width=60, height=60, seed=999)

Resource Distribution
---------------------

Resources spawn based on terrain:

- **Wood**: Forest tiles
- **Stone/Ore**: Mountain tiles
- **Fish**: Water-adjacent tiles
- **Berries/Herbs**: Grass and forest tiles

Accessing World Data
--------------------

.. code-block:: python

   # Get tile information
   tile = world.get_tile(x, y)
   print(f"Terrain: {tile.terrain_type}")
   print(f"Resources: {tile.resources}")

   # Check passability
   if world.is_passable(x, y):
       print("Agent can move here")

   # Get neighboring tiles
   neighbors = world.get_neighbors(x, y)

World Size Recommendations
--------------------------

==========  ==========  ===================
Size        Agents      Use Case
==========  ==========  ===================
20x20       5-10        Quick tests
40x40       10-20       Medium simulations
60x60       20-50       Standard research
100x100     50-100+     Large-scale studies
==========  ==========  ===================

Best Practices
--------------

1. Use consistent seeds for reproducible experiments
2. Match world size to agent count
3. Larger worlds allow more exploration
4. Save seed value for sharing results

See Also
--------

- :doc:`simulation-config` for world generation parameters
- :doc:`creating-agents` to populate your world
