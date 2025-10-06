Creating Agents
===============

This guide covers how to create and customize agents for your simulations.

Quick Agent Creation
--------------------

The simplest way to create agents:

.. code-block:: python

   from simulation_framework.src.entities.agent import create_random_agent

   # Create agent with random personality and class
   agent = create_random_agent(position=(10, 10), name="Alice")

Using Personality Archetypes
-----------------------------

Create agents with predefined personality templates:

.. code-block:: python

   from simulation_framework.src.entities.agent import create_agent_with_archetype

   # Available archetypes: explorer, warrior, peaceful, social,
   # crafter, merchant, aggressive, curious

   explorer = create_agent_with_archetype(
       position=(10, 10),
       name="Explorer Alice",
       archetype="explorer"
   )

   warrior = create_agent_with_archetype(
       position=(20, 10),
       name="Knight Bob",
       archetype="warrior"
   )

Archetype Definitions
~~~~~~~~~~~~~~~~~~~~~

============  ============================================
Archetype     Personality Traits
============  ============================================
explorer      High curiosity, moderate bravery
warrior       High bravery, low sociability
peaceful      Low bravery, high patience
social        High sociability, moderate greed
crafter       High patience, moderate greed
merchant      High sociability, high greed
aggressive    High bravery, low patience
curious       Very high curiosity, high sociability
============  ============================================

Custom Personalities
--------------------

Create agents with specific personality traits:

.. code-block:: python

   from simulation_framework.src.entities.agent import Agent
   from simulation_framework.src.ai.personality import Personality
   from simulation_framework.src.ai.character_class import get_character_class

   # Define custom personality
   personality = Personality(
       curiosity=0.9,     # Loves exploring
       bravery=0.3,       # Avoids combat
       sociability=0.7,   # Likes trading
       greed=0.4,         # Moderate resource gathering
       patience=0.8       # Sticks with goals
   )

   # Choose character class
   char_class = get_character_class("Hunter")

   # Create agent
   agent = Agent(
       position=(15, 15),
       name="Custom Agent",
       personality=personality,
       character_class=char_class
   )

Personality Trait Effects
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Curiosity** (0-1)
   - 0.0-0.3: Stays near spawn, focuses on gathering
   - 0.4-0.7: Moderate exploration
   - 0.8-1.0: Explores aggressively, prioritizes new areas

**Bravery** (0-1)
   - 0.0-0.3: Avoids combat, flees from enemies
   - 0.4-0.7: Fights when necessary
   - 0.8-1.0: Actively hunts enemies

**Sociability** (0-1)
   - 0.0-0.3: Rarely trades
   - 0.4-0.7: Trades occasionally
   - 0.8-1.0: Frequently seeks trading opportunities

**Greed** (0-1)
   - 0.0-0.3: Gathers minimum resources
   - 0.4-0.7: Balanced gathering
   - 0.8-1.0: Hoards resources aggressively

**Patience** (0-1)
   - 0.0-0.3: Switches goals frequently
   - 0.4-0.7: Moderate goal persistence
   - 0.8-1.0: Completes goals before switching

Character Classes
-----------------

Available Classes
~~~~~~~~~~~~~~~~~

.. code-block:: python

   from simulation_framework.src.ai.character_class import get_character_class

   # All available classes:
   warrior = get_character_class("Warrior")
   mage = get_character_class("Mage")
   hunter = get_character_class("Hunter")
   alchemist = get_character_class("Alchemist")
   blacksmith = get_character_class("Blacksmith")
   explorer = get_character_class("Explorer")
   trader = get_character_class("Trader")

Class Bonuses
~~~~~~~~~~~~~

**Warrior**
   - +15 HP, +3 Attack Power
   - Starts with Iron Sword
   - Bonus: Combat skills

**Mage**
   - +30 Magic, +10 Stamina
   - Starts with Wooden Staff
   - Bonus: Magic skills

**Hunter**
   - +10 HP, +15 Stamina
   - Starts with Bow, Arrows
   - Bonus: Gathering, tracking

**Alchemist**
   - +20 Magic, +10 Stamina
   - Starts with Herbs, Mortar & Pestle
   - Bonus: Herb gathering, potion crafting

**Blacksmith**
   - +10 HP, +10 Stamina
   - Starts with Hammer, Iron Ore
   - Bonus: Mining, weapon/tool crafting

**Explorer**
   - +15 Stamina
   - Starts with Map, Compass
   - Bonus: All gathering skills +1

**Trader**
   - +10 HP, +5 Stamina
   - Starts with 50 Gold
   - Bonus: Trading, haggling

Adding Initial Goals
--------------------

Give agents starting objectives:

.. code-block:: python

   from simulation_framework.src.ai.goal import (
       ExploreGoal, GatherResourceGoal, CraftItemGoal, TradeGoal
   )

   agent = create_random_agent((10, 10), name="Alice")

   # Add initial goals
   agent.current_goals = [
       ExploreGoal(priority=7),
       GatherResourceGoal("wood", target_amount=20, priority=6),
       TradeGoal(priority=4)
   ]

Goal Priority
~~~~~~~~~~~~~

Priority values (1-10):
   - 1-3: Low priority (background goals)
   - 4-6: Medium priority (normal activities)
   - 7-8: High priority (important objectives)
   - 9-10: Critical priority (urgent needs)

Creating Specialist Agents
---------------------------

Woodcutter Specialist
~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   personality = Personality(
       curiosity=0.4,     # Some exploration
       bravery=0.3,       # Avoid combat
       sociability=0.5,   # Trade wood
       greed=0.7,         # Gather lots
       patience=0.8       # Persistent gathering
   )

   woodcutter = Agent(
       position=(10, 10),
       name="Woodcutter",
       personality=personality,
       character_class=get_character_class("Hunter")
   )

   woodcutter.current_goals = [
       GatherResourceGoal("wood", target_amount=50, priority=8)
   ]

Combat Specialist
~~~~~~~~~~~~~~~~~

.. code-block:: python

   personality = Personality(
       curiosity=0.6,     # Explore for enemies
       bravery=0.9,       # Fearless
       sociability=0.2,   # Lone wolf
       greed=0.4,         # Wants loot
       patience=0.6       # Persistent in combat
   )

   warrior = Agent(
       position=(20, 20),
       name="Warrior",
       personality=personality,
       character_class=get_character_class("Warrior")
   )

   # No specific goals - will hunt enemies naturally

Trader Specialist
~~~~~~~~~~~~~~~~~

.. code-block:: python

   personality = Personality(
       curiosity=0.5,     # Find other agents
       bravery=0.3,       # Avoid danger
       sociability=0.9,   # Very social
       greed=0.8,         # Profit-driven
       patience=0.7       # Wait for good trades
   )

   trader = Agent(
       position=(30, 30),
       name="Merchant",
       personality=personality,
       character_class=get_character_class("Trader")
   )

   trader.current_goals = [
       GatherResourceGoal("berries", target_amount=10, priority=5),
       TradeGoal(priority=8)
   ]

Batch Agent Creation
--------------------

Create Many Agents Efficiently
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   def create_diverse_agents(num_agents, world):
       agents = []
       archetypes = ["explorer", "warrior", "peaceful", "social",
                     "crafter", "merchant"]

       for i in range(num_agents):
           x = random.randint(5, world.width - 5)
           y = random.randint(5, world.height - 5)

           archetype = archetypes[i % len(archetypes)]
           name = f"Agent_{i}_{archetype}"

           agent = create_agent_with_archetype(
               position=(x, y),
               name=name,
               archetype=archetype
           )

           agents.append(agent)

       return agents

   # Usage
   agents = create_diverse_agents(20, simulation.world)
   for agent in agents:
       simulation.add_agent(agent)

Creating Balanced Teams
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   def create_balanced_team(start_pos):
       team = [
           # Tank
           create_agent_with_archetype(
               start_pos, "Tank", "warrior"
           ),
           # DPS
           create_agent_with_archetype(
               (start_pos[0]+2, start_pos[1]), "DPS", "aggressive"
           ),
           # Support
           create_agent_with_archetype(
               (start_pos[0]+4, start_pos[1]), "Healer", "peaceful"
           ),
           # Scout
           create_agent_with_archetype(
               (start_pos[0], start_pos[1]+2), "Scout", "explorer"
           ),
           # Merchant
           create_agent_with_archetype(
               (start_pos[0]+2, start_pos[1]+2), "Trader", "merchant"
           )
       ]

       return team

Agent Inspection
----------------

Check Agent State
~~~~~~~~~~~~~~~~~

.. code-block:: python

   print(f"Name: {agent.name}")
   print(f"Position: {agent.position}")
   print(f"Health: {agent.stats.health}/{agent.stats.max_health}")
   print(f"Stamina: {agent.stats.stamina}/{agent.stats.max_stamina}")
   print(f"Class: {agent.character_class.name}")

   print("\nPersonality:")
   for trait, value in agent.personality.to_dict().items():
       print(f"  {trait}: {value:.2f}")

   print("\nInventory:")
   for item, qty in agent.inventory.items.items():
       print(f"  {item.name}: {qty}")

   print("\nCurrent Goals:")
   for goal in agent.current_goals:
       print(f"  - {goal.name} (priority {goal.priority})")

Best Practices
--------------

1. **Diverse Personalities**

   Create agents with varied personalities for emergent interactions:

   .. code-block:: python

      # Avoid all agents being identical
      agents = [create_random_agent((i*5, i*5)) for i in range(10)]

2. **Match Class to Goals**

   Give agents goals that align with their class:

   .. code-block:: python

      warrior.current_goals = [ExploreGoal(), AttackEnemyGoal()]
      alchemist.current_goals = [GatherResourceGoal("herbs")]

3. **Reasonable Starting Positions**

   Avoid spawning agents in impassable terrain:

   .. code-block:: python

      while not world.is_passable(x, y):
           x, y = random.randint(0, world.width-1), random.randint(0, world.height-1)

4. **Limit Initial Goals**

   Don't overwhelm agents with too many starting goals:

   .. code-block:: python

      # Good: 1-3 initial goals
      agent.current_goals = [ExploreGoal(), GatherResourceGoal("wood")]

      # Bad: Too many goals
      agent.current_goals = [goal1, goal2, goal3, goal4, goal5]

Next Steps
----------

- Learn about :doc:`world-generation` to create suitable environments
- See :doc:`running-simulations` to execute your custom agent configurations
- Read :doc:`../tutorials/custom-actions` to add new behaviors
