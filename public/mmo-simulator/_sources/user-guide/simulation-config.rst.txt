Simulation Configuration
========================

This guide covers all configuration options for customizing simulations.

SimulationConfig Class
----------------------

The ``SimulationConfig`` class controls all simulation parameters:

.. code-block:: python

   from simulation_framework.src.core.config import SimulationConfig

   config = SimulationConfig(
       # World settings
       world_width=60,
       world_height=60,
       world_seed=42,

       # Simulation settings
       max_ticks=1000,
       tick_rate=10,

       # Database settings
       database_path="simulation.db",
       save_interval=60,
       analytics_interval=60,
       log_actions=True,

       # Agent settings
       default_agent_vision_range=8,
       fog_of_war_enabled=True,

       # Visualization settings
       enable_visualizer=True,
       visualizer_width=1400,
       visualizer_height=900,
       visualizer_tile_size=16
   )

Configuration Parameters
------------------------

World Settings
~~~~~~~~~~~~~~

``world_width`` : int (default: 60)
   Width of the world grid in tiles.

``world_height`` : int (default: 60)
   Height of the world grid in tiles.

``world_seed`` : int (default: random)
   Random seed for procedural world generation. Use the same seed to generate identical worlds.

   .. code-block:: python

      # Reproducible world
      config = SimulationConfig(world_seed=12345)

Simulation Settings
~~~~~~~~~~~~~~~~~~~

``max_ticks`` : int (default: 10000)
   Maximum number of simulation ticks before auto-stop.

``tick_rate`` : int (default: 10)
   Target ticks per second. Set to 0 for unlimited speed.

   .. note::
      Higher tick rates slow down simulation for visualization. Use ``tick_rate=0`` for headless runs.

Database Settings
~~~~~~~~~~~~~~~~~

``database_path`` : str (default: "simulation.db")
   Path to SQLite database file for logging.

``save_interval`` : int (default: 60)
   How often (in ticks) to save agent/world snapshots.

   .. code-block:: python

      # Save every 10 ticks for detailed history
      config = SimulationConfig(save_interval=10)

      # Save every 300 ticks for less overhead
      config = SimulationConfig(save_interval=300)

``analytics_interval`` : int (default: 60)
   How often (in ticks) to calculate analytics metrics.

``log_actions`` : bool (default: True)
   Whether to log all actions to database. Disable for faster simulations at cost of detail.

Agent Settings
~~~~~~~~~~~~~~

``default_agent_vision_range`` : int (default: 8)
   How far (in tiles) agents can see. Affects fog of war updates.

``fog_of_war_enabled`` : bool (default: True)
   Whether agents use fog of war (limited knowledge) or see entire map.

   .. code-block:: python

      # Omniscient agents (see everything)
      config = SimulationConfig(fog_of_war_enabled=False)

Visualization Settings
~~~~~~~~~~~~~~~~~~~~~~

``enable_visualizer`` : bool (default: True)
   Whether to use Pygame visualization. Set False for headless runs.

``visualizer_width`` : int (default: 1400)
   Window width in pixels.

``visualizer_height`` : int (default: 900)
   Window height in pixels.

``visualizer_tile_size`` : int (default: 16)
   Size of each tile in pixels.

   .. tip::
      For large worlds, reduce ``visualizer_tile_size`` or increase window size:

      .. code-block:: python

         config = SimulationConfig(
             world_width=100,
             world_height=100,
             visualizer_tile_size=10,  # Smaller tiles
             visualizer_width=1600,     # Larger window
             visualizer_height=1200
         )

Configuration Examples
----------------------

Fast Headless Simulation
~~~~~~~~~~~~~~~~~~~~~~~~~

Maximize speed for large-scale experiments:

.. code-block:: python

   config = SimulationConfig(
       world_width=100,
       world_height=100,
       max_ticks=5000,
       tick_rate=0,                    # Unlimited speed
       enable_visualizer=False,        # No visualization
       save_interval=300,              # Save less frequently
       analytics_interval=300,
       log_actions=False               # Skip action logs
   )

Detailed Analysis Simulation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Capture maximum detail for research:

.. code-block:: python

   config = SimulationConfig(
       world_width=60,
       world_height=60,
       max_ticks=2000,
       save_interval=10,               # Frequent snapshots
       analytics_interval=30,
       log_actions=True,               # Log everything
       fog_of_war_enabled=True,        # Realistic agent knowledge
       enable_visualizer=False         # Headless for speed
   )

Visual Demo Simulation
~~~~~~~~~~~~~~~~~~~~~~

Show off the simulation interactively:

.. code-block:: python

   config = SimulationConfig(
       world_width=40,
       world_height=40,
       max_ticks=1000,
       tick_rate=5,                    # Slow enough to watch
       enable_visualizer=True,
       visualizer_width=1200,
       visualizer_height=800,
       visualizer_tile_size=20         # Larger tiles
   )

Reproducible Experiments
~~~~~~~~~~~~~~~~~~~~~~~~

Run identical simulations:

.. code-block:: python

   import random

   # Set all random seeds
   SEED = 12345
   random.seed(SEED)

   config = SimulationConfig(
       world_seed=SEED,
       max_ticks=1000,
       database_path=f"experiment_{SEED}.db"
   )

Advanced Configuration
----------------------

Modifying Configuration at Runtime
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Some settings can be changed during simulation:

.. code-block:: python

   simulation = Simulation(config)
   simulation.initialize_simulation("My Sim")

   # Change tick rate mid-simulation
   simulation.config.tick_rate = 20

   # Pause/resume
   simulation.pause_simulation()
   # ... do something ...
   simulation.resume_simulation()

Configuration Profiles
~~~~~~~~~~~~~~~~~~~~~~

Create reusable configuration profiles:

.. code-block:: python

   # profiles.py
   from simulation_framework.src.core.config import SimulationConfig

   PROFILES = {
       "fast": SimulationConfig(
           tick_rate=0,
           enable_visualizer=False,
           save_interval=300
       ),
       "visual": SimulationConfig(
           tick_rate=10,
           enable_visualizer=True,
           visualizer_tile_size=18
       ),
       "research": SimulationConfig(
           save_interval=10,
           log_actions=True,
           analytics_interval=30
       )
   }

   # Use in your script
   config = PROFILES["research"]
   config.world_seed = 42

Configuration Validation
~~~~~~~~~~~~~~~~~~~~~~~~

The config class validates parameters:

.. code-block:: python

   # This will raise ValueError
   config = SimulationConfig(
       world_width=-10  # Must be positive
   )

   # This will warn
   config = SimulationConfig(
       tick_rate=1000  # Very high, likely a mistake
   )

Best Practices
--------------

1. **Use Seeds for Reproducibility**

   Always set ``world_seed`` for experiments you want to reproduce:

   .. code-block:: python

      config = SimulationConfig(world_seed=42)

2. **Match Save Interval to Analysis Needs**

   - Fine-grained analysis: ``save_interval=10``
   - General trends: ``save_interval=100``
   - Large-scale sims: ``save_interval=300``

3. **Disable Visualization for Long Runs**

   Visualization adds overhead. For simulations >1000 ticks, use headless mode:

   .. code-block:: python

      config = SimulationConfig(enable_visualizer=False)

4. **Use Realistic Agent Vision**

   Keep ``fog_of_war_enabled=True`` for realistic agent behavior:

   .. code-block:: python

      config = SimulationConfig(
           fog_of_war_enabled=True,
           default_agent_vision_range=8
       )

5. **Size World Appropriately**

   - Small (20x20): Quick tests, 5-10 agents
   - Medium (60x60): Standard sims, 20-50 agents
   - Large (100x100): Long-term studies, 50-100+ agents

Next Steps
----------

- Learn about :doc:`creating-agents` with custom personalities
- Explore :doc:`world-generation` for terrain customization
- See :doc:`running-simulations` for execution options
