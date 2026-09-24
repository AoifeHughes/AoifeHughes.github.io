Analyzing Simulation Results
============================

Learn how to extract insights from simulation data.

Database Connection
-------------------

Connect to the SQLite database:

.. code-block:: python

   import sqlite3
   import pandas as pd

   conn = sqlite3.connect("simulation.db")

Basic Queries
-------------

Action Distribution
~~~~~~~~~~~~~~~~~~~

.. code-block:: sql

   SELECT action_type, COUNT(*) as count,
          SUM(CASE WHEN success = 1 THEN 1 ELSE 0 END) as successful,
          AVG(duration) as avg_duration
   FROM action_logs
   GROUP BY action_type
   ORDER BY count DESC;

Combat Statistics
~~~~~~~~~~~~~~~~~

.. code-block:: sql

   SELECT attacker_id,
          COUNT(*) as attacks,
          SUM(damage_dealt) as total_damage,
          AVG(damage_dealt) as avg_damage,
          SUM(CASE WHEN target_died = 1 THEN 1 ELSE 0 END) as kills
   FROM combat_logs
   GROUP BY attacker_id
   ORDER BY kills DESC;

Trading Patterns
~~~~~~~~~~~~~~~~

.. code-block:: sql

   SELECT initiator_id, target_id,
          COUNT(*) as trades,
          offered_items,
          requested_items
   FROM trade_logs
   WHERE completed = 1
   GROUP BY initiator_id, target_id;

Python Analysis
---------------

Using Pandas
~~~~~~~~~~~~

.. code-block:: python

   import pandas as pd

   # Load action logs
   actions = pd.read_sql_query("SELECT * FROM action_logs", conn)

   # Success rate by action type
   success_rate = actions.groupby('action_type')['success'].mean()
   print(success_rate.sort_values(ascending=False))

   # Actions over time
   actions_per_tick = actions.groupby('tick').size()
   actions_per_tick.plot(title='Activity Over Time')

Agent Performance
~~~~~~~~~~~~~~~~~

.. code-block:: python

   # Get final agent states
   final_tick = pd.read_sql_query(
       "SELECT MAX(tick) as max_tick FROM agent_snapshots",
       conn
   ).iloc[0]['max_tick']

   final_agents = pd.read_sql_query(
       f"SELECT * FROM agent_snapshots WHERE tick = {final_tick}",
       conn
   )

   # Agents by health
   print(final_agents[['name', 'health', 'max_health']].sort_values('health'))

   # Inventory sizes
   print(final_agents[['name', 'inventory_items']].sort_values('inventory_items', ascending=False))

Economic Analysis
-----------------

Resource Gathering Rates
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   gather_actions = pd.read_sql_query("""
       SELECT agent_id, tick, action_data
       FROM action_logs
       WHERE action_type LIKE '%Gather%' AND success = 1
   """, conn)

   # Parse JSON action_data
   import json
   gather_actions['resource'] = gather_actions['action_data'].apply(
       lambda x: json.loads(x).get('resource_type')
   )

   # Resources per agent
   resources_gathered = gather_actions.groupby(['agent_id', 'resource']).size()
   print(resources_gathered.unstack(fill_value=0))

Trade Network Visualization
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   import networkx as nx
   import matplotlib.pyplot as plt

   trades = pd.read_sql_query(
       "SELECT initiator_id, target_id FROM trade_logs WHERE completed = 1",
       conn
   )

   # Create trade network
   G = nx.from_pandas_edgelist(
       trades,
       source='initiator_id',
       target='target_id',
       create_using=nx.DiGraph()
   )

   # Visualize
   nx.draw(G, with_labels=True, node_color='lightblue', node_size=500)
   plt.title("Trade Network")
   plt.show()

Time Series Analysis
--------------------

Agent Health Over Time
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   agent_health = pd.read_sql_query("""
       SELECT tick, agent_id, name, health, max_health
       FROM agent_snapshots
       ORDER BY tick
   """, conn)

   # Plot health trajectories
   for agent_id in agent_health['agent_id'].unique()[:5]:
       agent_data = agent_health[agent_health['agent_id'] == agent_id]
       plt.plot(agent_data['tick'], agent_data['health'],
                label=agent_data['name'].iloc[0])

   plt.xlabel('Tick')
   plt.ylabel('Health')
   plt.legend()
   plt.title('Agent Health Over Time')
   plt.show()

Exploration Progress
~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # Count unique positions visited per agent
   snapshots = pd.read_sql_query("""
       SELECT tick, agent_id, position_x, position_y
       FROM agent_snapshots
   """, conn)

   snapshots['position'] = list(zip(snapshots['position_x'], snapshots['position_y']))

   exploration = snapshots.groupby(['agent_id', 'tick'])['position'].nunique()
   exploration.unstack(level=0).plot(title='Exploration Over Time')

Advanced Analytics
------------------

Using the built-in analytics script:

.. code-block:: bash

   python analyze_simulation_results.py simulation.db

This generates:

- Summary statistics
- Action distribution charts
- Combat analysis
- Trade networks
- Resource flow diagrams
- Agent performance rankings

Export Results
--------------

Export for external analysis:

.. code-block:: python

   # Export to CSV
   actions.to_csv('actions.csv', index=False)
   final_agents.to_csv('final_agents.csv', index=False)

   # Export to Excel
   with pd.ExcelWriter('simulation_results.xlsx') as writer:
       actions.to_excel(writer, sheet_name='Actions')
       final_agents.to_excel(writer, sheet_name='Agents')
       trades.to_excel(writer, sheet_name='Trades')

Next Steps
----------

- Experiment with different agent configurations
- Compare multiple simulation runs
- Publish findings from your research
