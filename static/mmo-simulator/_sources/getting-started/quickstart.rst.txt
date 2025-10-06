Quick Start Guide
=================

This guide will help you run your first simulation in under 5 minutes.

Your First Simulation
---------------------

The simplest way to start is with the included example script:

.. code-block:: bash

   python examples/complex_simulation.py --agents 10 --npcs 5 --ticks 180

This command will:

- Generate a 60x60 procedural world
- Spawn 10 agents with different personalities and classes
- Spawn 5 hostile NPCs (goblins and wolves)
- Run the simulation for 180 ticks (~3 simulation minutes)
- Display real-time visualization with Pygame
- Save all data to ``complex_simulation.db``

Understanding the Output
~~~~~~~~~~~~~~~~~~~~~~~~

You'll see output like this:

.. code-block:: text

   ===========================================================
   COMPLEX MMO SIMULATION
   ===========================================================
   World Size: 60x60
   Agents: 10
   NPCs: 5
   Duration: 180 ticks (~3.0 minutes)
   Database: complex_simulation.db
   ===========================================================

   Creating 10 specialized agents...
     + Woodcutter Alice (Hunter) - Goals: GatherResourceGoal
     + Miner Bob (Warrior) - Goals: GatherResourceGoal
     ...

   Creating 5 NPCs...
     + Goblin Raider (goblin) - HP: 45, ATK: 12
     ...

The visualization window will show:

- **Terrain**: Water (blue), grass (green), forest (dark green), mountains (gray)
- **Agents**: Colored circles (each agent has a unique color)
- **NPCs**: Red circles
- **Resources**: Small icons on tiles

Simulation Controls
~~~~~~~~~~~~~~~~~~~

While the simulation runs:

- **Left Click + Drag**: Pan the map
- **Mouse Wheel**: Zoom in/out
- **Click an Agent**: View detailed stats
- **ESC**: Deselect agent
- **Close Window**: Stop simulation

Running Headless
~~~~~~~~~~~~~~~~

To run without visualization (faster for large simulations):

.. code-block:: bash

   python examples/complex_simulation.py --agents 20 --npcs 10 --ticks 500 --no-visual

Analyzing Results
-----------------

After the simulation completes, inspect the database:

.. code-block:: bash

   sqlite3 complex_simulation.db

Try these queries:

.. code-block:: sql

   -- View all tables
   .tables

   -- See action distribution
   SELECT action_type, COUNT(*) as count
   FROM action_logs
   GROUP BY action_type
   ORDER BY count DESC;

   -- View combat events
   SELECT * FROM combat_logs
   LIMIT 10;

   -- Check agent final states
   SELECT name, health, position_x, position_y
   FROM agent_snapshots
   WHERE tick = (SELECT MAX(tick) FROM agent_snapshots);

Or use the included analysis script:

.. code-block:: bash

   python analyze_simulation_results.py complex_simulation.db

Customizing Your Simulation
----------------------------

Command-Line Options
~~~~~~~~~~~~~~~~~~~~

The example script accepts many options:

.. code-block:: bash

   python examples/complex_simulation.py \
       --width 80 \              # World width
       --height 80 \             # World height
       --agents 25 \             # Number of agents
       --npcs 15 \               # Number of NPCs
       --ticks 600 \             # Simulation duration
       --seed 12345 \            # Random seed (for reproducibility)
       --db-file mysim.db \      # Database filename
       --no-visual               # Run without visualization

Example: Large Simulation
~~~~~~~~~~~~~~~~~~~~~~~~~~

Run a larger, longer simulation:

.. code-block:: bash

   python examples/complex_simulation.py \
       --width 100 \
       --height 100 \
       --agents 50 \
       --npcs 30 \
       --ticks 1200 \
       --no-visual

This will take longer but generate rich data for analysis.

Creating a Simple Custom Simulation
------------------------------------

Create a file ``my_simulation.py``:

.. code-block:: python

   from simulation_framework.src.core.simulation import Simulation
   from simulation_framework.src.core.config import SimulationConfig
   from simulation_framework.src.entities.agent import create_random_agent
   from simulation_framework.src.entities.npc import create_basic_goblin

   # Configure simulation
   config = SimulationConfig(
       world_width=40,
       world_height=40,
       world_seed=42,
       max_ticks=300,
       database_path="my_sim.db"
   )

   # Create simulation
   sim = Simulation(config)
   sim.initialize_simulation("My First Simulation")

   # Add 5 random agents
   for i in range(5):
       agent = create_random_agent((10 + i*5, 10 + i*5))
       sim.add_agent(agent)

   # Add 3 goblins
   for i in range(3):
       npc = create_basic_goblin((30, 10 + i*10))
       sim.add_npc(npc)

   # Run simulation
   sim.run(num_ticks=300)

   # Print statistics
   stats = sim.get_statistics()
   print(f"Simulation completed: {stats['current_tick']} ticks")
   print(f"Active agents: {stats['active_agents']}/{stats['total_agents']}")

Run it:

.. code-block:: bash

   python my_simulation.py

Common Use Cases
----------------

Experiment 1: Peaceful Gathering
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Agents gathering resources without enemies:

.. code-block:: bash

   python examples/complex_simulation.py --agents 15 --npcs 0 --ticks 600

Experiment 2: Combat Arena
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Lots of combat with many enemies:

.. code-block:: bash

   python examples/complex_simulation.py --agents 10 --npcs 20 --ticks 400

Experiment 3: Economic Simulation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Large population for emergent trading:

.. code-block:: bash

   python examples/complex_simulation.py --agents 40 --npcs 5 --ticks 1000

Next Steps
----------

- Learn about :doc:`basic-concepts` like entities, actions, and goals
- Read the :doc:`../user-guide/simulation-config` for detailed configuration
- Explore :doc:`../tutorials/custom-agents` to create specialized agent types
- Check out :doc:`../tutorials/analyzing-results` for data analysis techniques
