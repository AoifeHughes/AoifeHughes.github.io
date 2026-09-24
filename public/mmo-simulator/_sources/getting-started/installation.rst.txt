Installation
============

Requirements
------------

MMO Simulator requires:

- Python 3.8 or higher
- pip (Python package manager)
- Git (for cloning the repository)

System Requirements
~~~~~~~~~~~~~~~~~~~

- **OS**: Windows, macOS, or Linux
- **RAM**: Minimum 2GB (4GB+ recommended for large simulations)
- **Storage**: ~100MB for code + variable space for simulation databases

Installation Steps
------------------

1. Clone the Repository
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   git clone https://github.com/AoifeHughes/MMO_Simulator.git
   cd MMO_Simulator

2. Create a Virtual Environment (Recommended)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Create virtual environment
   python -m venv venv

   # Activate it
   # On macOS/Linux:
   source venv/bin/activate

   # On Windows:
   venv\Scripts\activate

3. Install Dependencies
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   pip install -r requirements.txt

This will install:

- **pytest** (≥7.0.0) - Testing framework
- **pytest-cov** (≥4.0.0) - Test coverage
- **numpy** (≥1.20.0) - Numerical computing
- **opensimplex** (≥0.4.0) - Perlin noise for world generation
- **pathfinding** (≥1.0.0) - A* pathfinding
- **pygame** (≥2.0.0) - Visualization (optional)

Optional: Install Documentation Tools
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you want to build the documentation locally:

.. code-block:: bash

   pip install -r docs/requirements.txt

Verify Installation
-------------------

Run the test suite to verify everything is working:

.. code-block:: bash

   pytest

You should see all tests passing. If you encounter any issues, see the Troubleshooting section below.

Quick Test Run
~~~~~~~~~~~~~~

Run a quick simulation to ensure everything works:

.. code-block:: bash

   python examples/complex_simulation.py --agents 5 --npcs 3 --ticks 60 --no-visual

You should see output indicating the simulation is running, followed by statistics and database information.

Troubleshooting
---------------

ImportError: No module named 'pygame'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you get this error and don't need visualization:

.. code-block:: bash

   python examples/complex_simulation.py --no-visual

To install pygame:

.. code-block:: bash

   pip install pygame>=2.0.0

PathFinding Module Issues
~~~~~~~~~~~~~~~~~~~~~~~~~~

If you encounter issues with the pathfinding library:

.. code-block:: bash

   pip uninstall pathfinding
   pip install pathfinding==1.0.0

Python Version Issues
~~~~~~~~~~~~~~~~~~~~~

Ensure you're using Python 3.8+:

.. code-block:: bash

   python --version

If needed, use a specific Python version:

.. code-block:: bash

   python3.10 -m venv venv

Development Installation
------------------------

If you plan to contribute or modify the code:

.. code-block:: bash

   # Install in editable mode
   pip install -e .

   # Install development dependencies
   pip install pytest pytest-cov black flake8

   # Run tests with coverage
   pytest --cov=simulation_framework

Next Steps
----------

Now that you have MMO Simulator installed:

- Continue to :doc:`quickstart` to run your first simulation
- Read :doc:`basic-concepts` to understand the framework architecture
- Explore the :doc:`../examples/basic-simulation` examples
