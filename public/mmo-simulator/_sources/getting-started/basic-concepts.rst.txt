Basic Concepts
==============

This page introduces the core concepts and architecture of MMO Simulator.

Simulation Architecture
-----------------------

MMO Simulator uses an object-oriented, component-based architecture with three main layers:

1. **Entities**: Agents and NPCs that populate the world
2. **Actions**: Individual behaviors entities can perform
3. **Systems**: Managers that orchestrate entity interactions

The simulation runs in discrete time steps called **ticks**, typically 60 ticks = 1 simulation minute.

Entities
--------

Entities are objects that exist in the simulation world.

Agents
~~~~~~

**Agents** are autonomous entities with:

- **Position**: (x, y) coordinates in the world
- **Stats**: Health, stamina, magic, attack power
- **Inventory**: Items they carry
- **Personality**: Traits like curiosity, bravery, sociability (0-1 scale)
- **Character Class**: Warrior, Mage, Hunter, Alchemist, Blacksmith, etc.
- **Skills**: Levels in gathering, crafting, combat
- **Goals**: Prioritized list of objectives
- **Fog of War**: Internal map of explored areas

Example agent creation:

.. code-block:: python

   from simulation_framework.src.entities.agent import create_random_agent

   agent = create_random_agent(position=(10, 10), name="Explorer Alice")
   print(f"Personality: {agent.personality.curiosity:.2f} curiosity")
   print(f"Class: {agent.character_class.name}")

NPCs
~~~~

**NPCs** (Non-Player Characters) are simpler entities controlled by behavior scripts:

- **Hostile NPCs**: Attack agents on sight (goblins, wolves)
- **Neutral NPCs**: Ignore agents unless provoked
- **Tether Radius**: Maximum distance from spawn point
- **Aggro Range**: Distance at which they notice and attack agents
- **Loot Table**: Items dropped on death
- **Respawn System**: Automatically respawn after a delay

Example NPC creation:

.. code-block:: python

   from simulation_framework.src.entities.npc import create_basic_goblin

   goblin = create_basic_goblin(position=(25, 25))
   print(f"HP: {goblin.stats.max_health}")
   print(f"Attack: {goblin.stats.attack_power}")
   print(f"Aggro range: {goblin.aggro_range}")

Stats System
~~~~~~~~~~~~

All entities have a **Stats** component:

.. code-block:: python

   class Stats:
       health: int          # Current health
       max_health: int      # Maximum health
       stamina: int         # Current stamina
       max_stamina: int     # Maximum stamina
       magic: int           # Current magic points
       max_magic: int       # Maximum magic
       attack_power: int    # Base damage
       defense: int         # Damage reduction

Actions
-------

Actions are individual behaviors entities can perform. All actions inherit from a base ``Action`` class and implement:

- ``can_execute(actor, world)`` - Check if action is possible
- ``execute(actor, world)`` - Perform the action
- ``get_duration()`` - How many ticks the action takes
- ``get_cost()`` - Resource costs (stamina, items, etc.)

Action Categories
~~~~~~~~~~~~~~~~~

**Movement Actions**
   - ``MoveAction``: Move one tile
   - ``PathfindAction``: Multi-step pathfinding to destination
   - ``WanderAction``: Random exploration

**Gathering Actions**
   - ``GatherWoodAction``: Chop trees (requires axe)
   - ``MineAction``: Mine stone/ore (requires pickaxe)
   - ``ForageAction``: Collect herbs/berries
   - ``FishAction``: Catch fish (requires rod)

**Combat Actions**
   - ``MeleeAttackAction``: Close-range attack
   - ``RangedAttackAction``: Bow/crossbow attack
   - ``MagicAttackAction``: Spell casting

**Crafting Actions**
   - ``CraftAction``: Create items from recipes

**Trading Actions**
   - ``TradeAction``: Exchange items with other agents

Example action execution:

.. code-block:: python

   from simulation_framework.src.actions.gathering import GatherWoodAction

   action = GatherWoodAction(target_position=(15, 20))

   if action.can_execute(agent, world):
       result = action.execute(agent, world)
       print(f"Success: {result.success}")
       print(f"Message: {result.message}")

Goals
-----

Goals are high-level objectives that guide agent behavior. The AI system evaluates goals using **utility theory** to select which goal to pursue.

Goal Types
~~~~~~~~~~

**ExploreGoal**
   Discover new areas of the map. Preferred by agents with high curiosity.

**GatherResourceGoal**
   Collect specific resources (wood, stone, herbs, fish). Takes class skills into account.

**CraftItemGoal**
   Create items from recipes. Requires gathering ingredients first.

**AttackEnemyGoal**
   Hunt and defeat NPCs. Preferred by brave agents and warrior classes.

**TradeGoal**
   Find other agents and exchange goods. Preferred by social agents and traders.

Goal Priority System
~~~~~~~~~~~~~~~~~~~~

Each goal has a **priority** (1-10) and **utility score** (0-1):

.. code-block:: python

   # Utility considers:
   # - Agent personality
   # - Character class bonuses
   # - Current needs (health, inventory space)
   # - Environmental factors (nearby resources, enemies)

   for goal in possible_goals:
       utility = goal.get_utility(agent, world)
       # Higher utility = more likely to pursue

Agents maintain a goal queue and work toward the highest-priority achievable goal.

World
-----

The world is a procedurally-generated 2D grid.

Terrain Types
~~~~~~~~~~~~~

- **Water**: Impassable, fishable
- **Grass**: Passable, forageable (berries, herbs)
- **Forest**: Passable, has trees (wood), forageable
- **Mountain**: Impassable, mineable (stone, ore)
- **Desert**: Passable, sparse resources

World Generation
~~~~~~~~~~~~~~~~

Uses **Perlin noise** for realistic terrain:

.. code-block:: python

   from simulation_framework.src.core.world import World

   world = World(width=60, height=60, seed=42)

   # Check a tile
   tile = world.get_tile(10, 10)
   print(f"Terrain: {tile.terrain_type}")
   print(f"Passable: {world.is_passable(10, 10)}")

Resources are procedurally placed based on terrain type. See :doc:`../user-guide/world-generation` for details.

Fog of War
~~~~~~~~~~

Agents don't know the entire map initially. They maintain an internal **FogOfWar** map that updates as they explore:

.. code-block:: python

   # Agent can only pathfind to explored areas
   if agent.fog_of_war.is_explored(target_x, target_y):
       path = pathfinder.find_path(agent.position, target)

Vision range is configurable (default: 8 tiles).

Systems
-------

Systems manage global simulation mechanics.

Trading System
~~~~~~~~~~~~~~

Non-blocking market where agents:

1. Post **TradeOffers** (offering items, requesting items)
2. Other agents browse offers
3. Matching trades execute when agents meet

.. code-block:: python

   # Agent A posts offer
   offer = TradeOffer(
       offering={"wood": 10},
       requesting={"stone": 5}
   )
   trading_system.post_offer(agent_a, offer)

   # Agent B finds matching offer
   matches = trading_system.find_matches(agent_b)

Respawn Manager
~~~~~~~~~~~~~~~

Handles entity death and respawning:

- **Safe zones**: Areas where entities respawn
- **Respawn delay**: Time before entity returns (agents: 150 ticks, NPCs: 100 ticks)
- **Stat reset**: Entities respawn with full health

Combat Resolver
~~~~~~~~~~~~~~~

Calculates damage, critical hits, and applies effects:

.. code-block:: python

   damage = combat_resolver.calculate_damage(
       attacker=agent,
       defender=npc,
       attack_type="melee"
   )

Personality System
------------------

Each agent has a **Personality** with five traits (0-1 scale):

**Curiosity**
   How much they explore. High curiosity → frequent ``ExploreGoal``.

**Bravery**
   Willingness to fight. High bravery → frequent ``AttackEnemyGoal``.

**Sociability**
   Interest in trading. High sociability → frequent ``TradeGoal``.

**Greed**
   Desire for resources. Affects gathering priorities.

**Patience**
   How long they stick with goals before switching.

Example:

.. code-block:: python

   from simulation_framework.src.ai.personality import Personality

   # Create specific personality
   explorer = Personality(
       curiosity=0.9,
       bravery=0.4,
       sociability=0.3,
       greed=0.5,
       patience=0.7
   )

   # Or randomize
   random_personality = Personality.randomize()

Character Classes
-----------------

Classes provide starting bonuses and influence decision-making:

============  ===================  =================
Class         Skill Bonuses        Starting Items
============  ===================  =================
Warrior       Combat +2            Iron Sword, Shield
Hunter        Gathering +2         Bow, Arrows
Mage          Magic +3             Staff, Mana Potion
Alchemist     Crafting +2          Herbs, Mortar
Blacksmith    Crafting +3          Hammer, Anvil
Explorer      All +1               Map, Compass
Trader        Haggling +2          Gold, Trade Goods
============  ===================  =================

Database Logging
----------------

All simulation data is logged to SQLite:

**Tables**:
   - ``simulation_runs``: Metadata about each simulation
   - ``agent_snapshots``: Agent states at intervals
   - ``world_snapshots``: World state at intervals
   - ``action_logs``: Every action performed
   - ``combat_logs``: Detailed combat events
   - ``trade_logs``: Completed trades

This enables rich post-simulation analysis. See :doc:`../tutorials/analyzing-results`.

The Simulation Loop
-------------------

Each tick:

1. **Update NPCs**: Run NPC AI (aggro checks, behaviors)
2. **Agent Perception**: Update fog of war, detect entities
3. **Agent Decision**: Evaluate goals, select next action
4. **Execute Actions**: Process all queued actions
5. **Update Systems**: Trading, respawns, market prices
6. **Database Logging**: Save snapshots and events

See :doc:`../architecture/simulation-loop` for detailed flow diagrams.

Next Steps
----------

Now that you understand the basics:

- Explore the :doc:`../api/core` for detailed API documentation
- Read :doc:`../user-guide/creating-agents` to design custom agents
- Check out :doc:`../architecture/design-philosophy` for deeper insights
