Creating Custom Agents
======================

Tutorial for designing specialized agent types.

Example: Peaceful Herbalist
----------------------------

Create an agent that focuses on gathering herbs and avoiding combat:

.. code-block:: python

   from simulation_framework.src.entities.agent import Agent
   from simulation_framework.src.ai.personality import Personality
   from simulation_framework.src.ai.character_class import get_character_class
   from simulation_framework.src.ai.goal import GatherResourceGoal, TradeGoal

   # Define personality
   personality = Personality(
       curiosity=0.5,      # Moderate exploration
       bravery=0.1,        # Very cautious
       sociability=0.8,    # Likes to trade
       greed=0.6,          # Gathers resources
       patience=0.9        # Very persistent
   )

   # Create agent
   herbalist = Agent(
       position=(20, 20),
       name="Herbalist Emma",
       personality=personality,
       character_class=get_character_class("Alchemist")
   )

   # Set initial goals
   herbalist.current_goals = [
       GatherResourceGoal("herbs", target_amount=30, priority=8),
       TradeGoal(priority=6)
   ]

Example: Aggressive Scout
--------------------------

Create an agent that explores and hunts enemies:

.. code-block:: python

   from simulation_framework.src.ai.goal import ExploreGoal, AttackEnemyGoal

   personality = Personality(
       curiosity=0.9,      # Loves exploring
       bravery=0.8,        # Brave in combat
       sociability=0.2,    # Lone wolf
       greed=0.4,          # Moderate gathering
       patience=0.6        # Moderate persistence
   )

   scout = Agent(
       position=(30, 30),
       name="Scout Ranger",
       personality=personality,
       character_class=get_character_class("Hunter")
   )

   scout.current_goals = [
       ExploreGoal(priority=7),
       AttackEnemyGoal(priority=6)
   ]

Custom Goal Creation
--------------------

Extend the Goal base class for custom behaviors:

.. code-block:: python

   from simulation_framework.src.ai.goal import Goal

   class PatrolGoal(Goal):
       def __init__(self, waypoints, priority=5):
           super().__init__(priority, "Patrol")
           self.waypoints = waypoints
           self.current_waypoint = 0

       def is_complete(self, agent, world):
           # Never completes (infinite patrol)
           return False

       def is_valid(self, agent, world):
           return True

       def get_next_action(self, agent, world):
           from simulation_framework.src.actions.movement import PathfindAction

           target = self.waypoints[self.current_waypoint]

           # Check if reached waypoint
           if agent.position == target:
               self.current_waypoint = (self.current_waypoint + 1) % len(self.waypoints)
               target = self.waypoints[self.current_waypoint]

           return PathfindAction(target_position=target)

       def get_utility(self, agent, world):
           return 0.5  # Medium utility

   # Use custom goal
   guard = Agent((10, 10), name="Guard")
   guard.current_goals = [
       PatrolGoal(waypoints=[(10, 10), (10, 30), (30, 30), (30, 10)], priority=8)
   ]

Testing Your Agents
-------------------

Create a small test simulation:

.. code-block:: python

   from simulation_framework.src.core.simulation import Simulation
   from simulation_framework.src.core.config import SimulationConfig

   config = SimulationConfig(
       world_width=40,
       world_height=40,
       max_ticks=500,
       enable_visualizer=True
   )

   sim = Simulation(config)
   sim.initialize_simulation("Custom Agent Test")

   # Add your custom agents
   sim.add_agent(herbalist)
   sim.add_agent(scout)

   # Run and observe
   sim.run_with_visualizer(num_ticks=500)

   # Check results
   print(f"Herbalist inventory: {herbalist.inventory.items}")
   print(f"Scout explored: {len(scout.known_map.explored_tiles)}")

Next Steps
----------

- See :doc:`custom-actions` for creating new action types
- Read :doc:`analyzing-results` to study agent behavior
