Creating Custom Actions
=======================

Tutorial for adding new action types to the simulation.

Action Base Class
-----------------

All actions inherit from the base Action class:

.. code-block:: python

   from simulation_framework.src.actions.base import Action, ActionResult

   class CustomAction(Action):
       def __init__(self, param1, param2):
           super().__init__()
           self.param1 = param1
           self.param2 = param2

       def can_execute(self, actor, world):
           """Check if action can be performed"""
           # Verify preconditions
           return True

       def execute(self, actor, world):
           """Perform the action"""
           # Do something
           return ActionResult(
               success=True,
               message="Action completed",
               events=[]
           )

       def get_duration(self):
           """How many ticks this action takes"""
           return 1

       def get_cost(self):
           """Resource costs (stamina, items, etc.)"""
           from simulation_framework.src.actions.base import ResourceCost
           return ResourceCost(stamina=5)

Example: Rest Action
--------------------

Create an action that restores stamina:

.. code-block:: python

   from simulation_framework.src.actions.base import Action, ActionResult, ResourceCost

   class RestAction(Action):
       def __init__(self, duration=10):
           super().__init__()
           self.duration = duration
           self.start_tick = None

       def can_execute(self, actor, world):
           # Can rest if stamina not full
           return actor.stats.stamina < actor.stats.max_stamina

       def execute(self, actor, world):
           if self.start_tick is None:
               self.start_tick = world.current_tick

           # Restore 2 stamina per tick
           actor.stats.restore_stamina(2)

           # Complete when duration reached or stamina full
           if (world.current_tick - self.start_tick >= self.duration or
               actor.stats.stamina >= actor.stats.max_stamina):
               return ActionResult(
                   success=True,
                   message=f"Rested for {world.current_tick - self.start_tick} ticks"
               )

           # Still in progress
           return ActionResult(success=True, message="Resting...")

       def get_duration(self):
           return self.duration

       def get_cost(self):
           return ResourceCost()  # No cost to rest

Example: Build Structure Action
--------------------------------

More complex action with resource requirements:

.. code-block:: python

   class BuildStructureAction(Action):
       def __init__(self, structure_type, position):
           super().__init__()
           self.structure_type = structure_type
           self.position = position
           self.work_done = 0
           self.work_required = 50

       def can_execute(self, actor, world):
           # Check has required materials
           if self.structure_type == "shelter":
               required = {"wood": 10, "stone": 5}
           else:
               return False

           for item_name, qty in required.items():
               if not actor.inventory.has_item_by_name(item_name, qty):
                   return False

           # Check position is valid and empty
           if not world.is_passable(*self.position):
               return False

           return True

       def execute(self, actor, world):
           if self.work_done == 0:
               # First tick: consume materials
               actor.inventory.remove_item_by_name("wood", 10)
               actor.inventory.remove_item_by_name("stone", 5)

           self.work_done += 1

           if self.work_done >= self.work_required:
               # Create structure in world
               world.add_structure(self.structure_type, self.position, actor.id)
               return ActionResult(
                   success=True,
                   message=f"Built {self.structure_type} at {self.position}"
               )

           return ActionResult(
               success=True,
               message=f"Building... ({self.work_done}/{self.work_required})"
           )

       def get_duration(self):
           return self.work_required

       def get_cost(self):
           return ResourceCost(stamina=2)  # 2 stamina per tick

Using Custom Actions
--------------------

Integrate with the goal system:

.. code-block:: python

   from simulation_framework.src.ai.goal import Goal

   class RestGoal(Goal):
       def __init__(self, priority=3):
           super().__init__(priority, "Rest")

       def is_complete(self, agent, world):
           return agent.stats.stamina >= agent.stats.max_stamina

       def is_valid(self, agent, world):
           return agent.stats.stamina < agent.stats.max_stamina

       def get_next_action(self, agent, world):
           return RestAction(duration=10)

       def get_utility(self, agent, world):
           # Higher utility when more tired
           stamina_pct = agent.stats.stamina / agent.stats.max_stamina
           return 1.0 - stamina_pct

   # Agent will rest when tired
   agent.current_goals.append(RestGoal(priority=7))

Testing Custom Actions
----------------------

.. code-block:: python

   # Create test agent
   agent = create_random_agent((10, 10))
   agent.stats.stamina = 20  # Low stamina

   # Test rest action
   rest = RestAction(duration=10)
   print(f"Can execute: {rest.can_execute(agent, world)}")

   result = rest.execute(agent, world)
   print(f"Result: {result.message}")
   print(f"Stamina: {agent.stats.stamina}")

Best Practices
--------------

1. **Validate in can_execute()**: Check all preconditions
2. **Handle progressive actions**: Track state across ticks
3. **Return meaningful messages**: Help with debugging
4. **Consider costs**: Balance action power with resource usage
5. **Test thoroughly**: Verify edge cases

Next Steps
----------

- See :doc:`../api/actions` for action API details
- Read :doc:`custom-agents` to integrate actions with agents
