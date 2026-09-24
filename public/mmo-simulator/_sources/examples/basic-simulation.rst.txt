Basic Simulation Example
========================

A minimal example to get started.

Simple Script
-------------

.. code-block:: python

   from simulation_framework.src.core.simulation import Simulation
   from simulation_framework.src.core.config import SimulationConfig
   from simulation_framework.src.entities.agent import create_random_agent

   # Configure simulation
   config = SimulationConfig(
       world_width=30,
       world_height=30,
       max_ticks=200,
       enable_visualizer=False,
       database_path="basic_sim.db"
   )

   # Create simulation
   sim = Simulation(config)
   sim.initialize_simulation("Basic Simulation")

   # Add 5 random agents
   for i in range(5):
       agent = create_random_agent(
           position=(5 + i*4, 5 + i*4),
           name=f"Agent_{i}"
       )
       sim.add_agent(agent)

   # Run simulation
   sim.run(num_ticks=200)

   # Print results
   stats = sim.get_statistics()
   print(f"Completed {stats['current_tick']} ticks")
   print(f"Active agents: {stats['active_agents']}/{stats['total_agents']}")

Run the script:

.. code-block:: bash

   python basic_simulation.py

Expected Output
---------------

::

   Completed 200 ticks
   Active agents: 5/5
   Average tick time: 0.0123s

Next Steps
----------

- Try :doc:`complex-simulation` for advanced features
- Modify agent personalities
- Add NPCs for combat
- Increase tick count for longer runs
