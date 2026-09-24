Complex Simulation Example
==========================

Full-featured simulation demonstrating all systems.

Overview
--------

The ``examples/complex_simulation.py`` script showcases:

- Diverse agents with specialized roles
- Hostile NPCs (goblins, wolves)
- Resource gathering and crafting
- Trading system
- Respawn mechanics
- Real-time visualization
- Comprehensive database logging

Running the Example
-------------------

.. code-block:: bash

   # Standard run
   python examples/complex_simulation.py

   # Custom parameters
   python examples/complex_simulation.py \
       --width 80 \
       --height 80 \
       --agents 25 \
       --npcs 15 \
       --ticks 600 \
       --seed 12345

   # Headless mode
   python examples/complex_simulation.py --no-visual --ticks 1000

Script Breakdown
----------------

Agent Creation
~~~~~~~~~~~~~~

The script creates specialized agents:

- **Woodcutters**: Gather wood
- **Miners**: Gather stone and ore
- **Herbalists**: Collect herbs
- **Fishers**: Catch fish
- **Crafters**: Create items (blacksmiths, alchemists)
- **Traders**: Facilitate market economy
- **Warriors**: Explore and combat NPCs

NPC Diversity
~~~~~~~~~~~~~

Multiple NPC types:

- **Goblin Raiders**: Aggressive, medium health
- **Wolves**: Fast, pack behavior
- **Shamans**: Ranged attackers

Each NPC has randomized stats for variety.

Respawn System
~~~~~~~~~~~~~~

Entities respawn in safe zones:

- 5 safe zones across the map
- Agents respawn after 150 ticks
- NPCs respawn after 100 ticks

Database Structure
~~~~~~~~~~~~~~~~~~

Logs every 60 ticks (1 simulation minute):

- Agent snapshots (position, health, inventory)
- World state (active entities, resources)
- All actions (gathering, combat, trading)
- Combat events (damage, kills)
- Trade transactions

Analyzing Results
-----------------

After running, inspect the database:

.. code-block:: bash

   sqlite3 complex_simulation.db

Example queries:

.. code-block:: sql

   -- Top gatherers
   SELECT agent_id, COUNT(*) as gather_count
   FROM action_logs
   WHERE action_type LIKE '%Gather%' AND success = 1
   GROUP BY agent_id
   ORDER BY gather_count DESC
   LIMIT 10;

   -- Combat statistics
   SELECT attacker_id,
          COUNT(*) as total_attacks,
          SUM(damage_dealt) as total_damage,
          SUM(CASE WHEN target_died = 1 THEN 1 ELSE 0 END) as kills
   FROM combat_logs
   GROUP BY attacker_id
   ORDER BY kills DESC;

Customization Ideas
-------------------

Modify the script to experiment:

1. **Pure Exploration**: Remove NPCs, add more explorers
2. **Combat Arena**: Many warriors vs many NPCs
3. **Economic Focus**: All traders and crafters
4. **Survival Mode**: Limited resources, harsh conditions

Example Customization
~~~~~~~~~~~~~~~~~~~~~

Add a custom agent archetype:

.. code-block:: python

   # In create_specialized_agents():
   {"name": "Lumberjack", "archetype": "crafter",
    "class": "Blacksmith",
    "goals": [GatherResourceGoal("wood", 100, priority=9)]}

Visualization Controls
----------------------

When running with visualization:

- **Left Click + Drag**: Pan camera
- **Mouse Wheel**: Zoom in/out
- **Click Agent**: Show detailed info
- **ESC**: Deselect agent
- **Close Window**: Stop simulation

What to Observe
---------------

Watch for emergent behaviors:

- **Trade networks**: Who trades with whom?
- **Specialization**: Do agents stick to their roles?
- **Combat patterns**: How do warriors handle threats?
- **Resource distribution**: Where do agents gather?
- **Exploration**: How quickly is the map revealed?

Performance Notes
-----------------

Typical performance:

- 10 agents, 5 NPCs: ~0.01s per tick
- 25 agents, 15 NPCs: ~0.03s per tick
- 50 agents, 30 NPCs: ~0.08s per tick

Use ``--no-visual`` for 5-10x speedup.

Next Steps
----------

- Modify agent personalities
- Create custom goals
- Add new action types
- Experiment with world sizes
- Analyze economic patterns

See :doc:`../tutorials/analyzing-results` for data analysis techniques.
