MMO Simulator Documentation
============================

Welcome to MMO Simulator, a multi-agent simulation framework for studying emergent behavior and economic patterns in autonomous agent systems.

.. image:: https://img.shields.io/badge/python-3.8+-blue.svg
   :target: https://www.python.org/downloads/
   :alt: Python Version

.. image:: https://img.shields.io/github/license/AoifeHughes/MMO_Simulator
   :target: https://github.com/AoifeHughes/MMO_Simulator/blob/main/LICENSE
   :alt: License

Overview
--------

MMO Simulator is a research framework inspired by games like Dwarf Fortress, designed to simulate autonomous agents that:

- 🗺️ **Explore** procedurally-generated 2D worlds with diverse terrain types
- 🪓 **Gather** resources (wood, stone, herbs, fish) using appropriate tools
- ⚔️ **Combat** hostile NPCs and collect loot
- 🛠️ **Craft** items from gathered materials using recipes
- 💰 **Trade** with other agents in an emergent market economy
- 🧠 **Decide** autonomously using personality-driven AI and utility-based goal selection

The framework logs all actions, combat, trades, and entity states to a SQLite database for post-simulation analysis of economic trends, resource distribution, and behavioral patterns.

Key Features
------------

**Flexible Architecture**
   Object-oriented design with extensible base classes for entities, actions, and items. Add new content through database definitions without code changes.

**Personality-Driven AI**
   Agents have unique personalities (curiosity, bravery, sociability, greed, patience) and character classes (Warrior, Mage, Hunter, Alchemist, etc.) that influence their decision-making.

**Goal-Based Behavior**
   Utility-based AI system where agents autonomously select and pursue goals like exploring, gathering resources, crafting items, attacking enemies, or trading.

**Emergent Economy**
   Non-blocking trading system where agents post offers and form trade networks based on supply and demand.

**Comprehensive Analytics**
   All simulation data logged to SQLite for analysis of economic patterns, social networks, and long-term adaptation.

**Real-time Visualization**
   Optional Pygame-based visualization showing agent movements, combat, resource gathering, and world state.

Quick Start
-----------

.. code-block:: bash

   # Clone the repository
   git clone https://github.com/AoifeHughes/MMO_Simulator.git
   cd MMO_Simulator

   # Install dependencies
   pip install -r requirements.txt

   # Run a basic simulation
   python examples/complex_simulation.py --agents 10 --npcs 5 --ticks 180

See :doc:`getting-started/installation` for detailed installation instructions and :doc:`getting-started/quickstart` for your first simulation.

Documentation Structure
-----------------------

.. toctree::
   :maxdepth: 2
   :caption: Getting Started

   getting-started/installation
   getting-started/quickstart
   getting-started/basic-concepts

.. toctree::
   :maxdepth: 2
   :caption: User Guide

   user-guide/simulation-config
   user-guide/creating-agents
   user-guide/world-generation
   user-guide/running-simulations

.. toctree::
   :maxdepth: 2
   :caption: API Reference

   api/core
   api/entities
   api/actions
   api/ai
   api/systems
   api/world
   api/items
   api/database

.. toctree::
   :maxdepth: 2
   :caption: Architecture

   architecture/design-philosophy
   architecture/simulation-loop
   architecture/database-schema

.. toctree::
   :maxdepth: 2
   :caption: Tutorials

   tutorials/custom-agents
   tutorials/custom-actions
   tutorials/analyzing-results

.. toctree::
   :maxdepth: 2
   :caption: Examples

   examples/basic-simulation
   examples/complex-simulation

Research Applications
---------------------

This framework is designed for research into:

- **Emergent Economics**: How do market prices, trade networks, and resource distribution emerge from individual agent decisions?
- **Behavioral Adaptation**: How do agents with different personalities and classes specialize and adapt over time?
- **Social Dynamics**: What relationship patterns and cooperation strategies develop?
- **Resource Management**: How efficiently do agents discover, extract, and utilize resources?

Contributing
------------

Contributions are welcome! Please see the `GitHub repository <https://github.com/AoifeHughes/MMO_Simulator>`_ for contribution guidelines.

License
-------

This project is licensed under the MIT License. See the LICENSE file for details.

Indices and Tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
