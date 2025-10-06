Database Schema
===============

Structure of the SQLite simulation database.

Core Tables
-----------

simulation_runs
~~~~~~~~~~~~~~~

Metadata about each simulation run:

- id (primary key)
- name
- description
- world_seed
- world_width, world_height
- start_time, end_time
- total_agents
- config (JSON)

agent_snapshots
~~~~~~~~~~~~~~~

Agent state at intervals:

- id (primary key)
- simulation_id (foreign key)
- agent_id
- tick
- name
- position_x, position_y
- health, max_health
- stamina, max_stamina
- personality (JSON)
- character_class
- skills (JSON)
- current_goals (JSON)
- inventory_items
- gold

world_snapshots
~~~~~~~~~~~~~~~

World state at intervals:

- id (primary key)
- simulation_id (foreign key)
- tick
- total_entities
- active_agents, active_npcs
- resource_nodes
- world_events (JSON)
- market_prices (JSON)

Event Tables
------------

action_logs
~~~~~~~~~~~

Every action performed:

- id (primary key)
- simulation_id (foreign key)
- tick
- agent_id
- action_type
- action_data (JSON)
- success (boolean)
- result_message
- duration

combat_logs
~~~~~~~~~~~

Detailed combat events:

- id (primary key)
- simulation_id (foreign key)
- tick
- attacker_id
- target_id
- damage_dealt
- damage_type
- was_critical (boolean)
- weapon_used
- target_died (boolean)

trade_logs
~~~~~~~~~~

Completed trades:

- id (primary key)
- simulation_id (foreign key)
- tick
- initiator_id
- target_id
- offered_items (JSON)
- requested_items (JSON)
- offered_gold
- requested_gold
- completed (boolean)

Analytics Tables
----------------

The analytics engine generates derived tables:

- economic_metrics
- social_networks
- resource_flows
- agent_performance

Query Examples
--------------

See :doc:`../tutorials/analyzing-results` for SQL query examples.
