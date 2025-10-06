Running Simulations
===================

Guide to executing and monitoring MMO Simulator simulations.

Basic Execution
---------------

Headless Mode
~~~~~~~~~~~~~

Run without visualization for maximum speed:

.. code-block:: python

   from simulation_framework.src.core.simulation import Simulation
   from simulation_framework.src.core.config import SimulationConfig

   config = SimulationConfig(enable_visualizer=False)
   sim = Simulation(config)
   sim.initialize_simulation("My Simulation")

   # Add agents and NPCs
   # ...

   # Run for specific number of ticks
   sim.run(num_ticks=1000)

Visual Mode
~~~~~~~~~~~

Run with Pygame visualization:

.. code-block:: python

   config = SimulationConfig(
       enable_visualizer=True,
       tick_rate=10  # 10 ticks per second
   )
   sim = Simulation(config)
   sim.initialize_simulation("Visual Simulation")

   # Add agents and NPCs
   # ...

   # Run with visualizer
   sim.run_with_visualizer(num_ticks=1000)

Command-Line Scripts
--------------------

Use the provided example scripts:

.. code-block:: bash

   # Basic simulation
   python examples/complex_simulation.py --help

   # Common options
   python examples/complex_simulation.py \
       --width 80 \
       --height 80 \
       --agents 25 \
       --npcs 15 \
       --ticks 600 \
       --seed 42 \
       --db-file mysim.db \
       --no-visual

Monitoring Simulation
---------------------

Real-Time Statistics
~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # Get current statistics
   stats = sim.get_statistics()
   print(f"Tick: {stats['current_tick']}")
   print(f"Active agents: {stats['active_agents']}/{stats['total_agents']}")
   print(f"Active NPCs: {stats['active_npcs']}/{stats['total_npcs']}")
   print(f"Avg tick time: {stats['average_tick_time']:.4f}s")

Progress Callbacks
~~~~~~~~~~~~~~~~~~

.. code-block:: python

   def on_tick(tick_number):
       if tick_number % 100 == 0:
           print(f"Progress: {tick_number} ticks completed")

   sim.on_tick_complete = on_tick
   sim.run(num_ticks=1000)

Pausing and Resuming
--------------------

.. code-block:: python

   # Pause simulation
   sim.pause_simulation()

   # Do something (inspect state, modify agents, etc.)

   # Resume
   sim.resume_simulation()

Stopping Simulations
--------------------

.. code-block:: python

   # Stop programmatically
   sim.stop_simulation()

   # Or use Ctrl+C for graceful shutdown
   try:
       sim.run(num_ticks=10000)
   except KeyboardInterrupt:
       print("Interrupted by user")

Conditional Execution
---------------------

Run until a condition is met:

.. code-block:: python

   def all_enemies_defeated(sim):
       alive_npcs = [n for n in sim.npcs if n.stats.is_alive()]
       return len(alive_npcs) == 0

   sim.run_until(condition=all_enemies_defeated)

Performance Tips
----------------

1. **Disable visualization** for long runs (10x+ speedup)
2. **Reduce save frequency** (``save_interval=300``)
3. **Disable action logging** if not needed
4. **Use appropriate world size** for agent count

Batch Simulations
-----------------

Run multiple simulations:

.. code-block:: python

   import multiprocessing

   def run_experiment(seed):
       config = SimulationConfig(
           world_seed=seed,
           enable_visualizer=False,
           database_path=f"sim_{seed}.db"
       )
       sim = Simulation(config)
       sim.initialize_simulation(f"Experiment {seed}")

       # Add agents
       # ...

       sim.run(num_ticks=1000)
       return seed

   # Run 10 simulations in parallel
   seeds = range(1, 11)
   with multiprocessing.Pool() as pool:
       results = pool.map(run_experiment, seeds)

Next Steps
----------

- See :doc:`../tutorials/analyzing-results` for data analysis
- Learn about :doc:`../architecture/simulation-loop` internals
