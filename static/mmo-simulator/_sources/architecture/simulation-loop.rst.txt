Simulation Loop
===============

Understanding the tick-based execution model.

The Main Loop
-------------

Each tick follows this sequence:

1. **Update NPCs**: Execute NPC AI behaviors
2. **Agent Perception**: Update fog of war, detect entities
3. **Agent Decision**: Evaluate goals, plan actions
4. **Execute Actions**: Process all queued actions
5. **Update Systems**: Trading, respawns, market prices
6. **Database Logging**: Save snapshots and events
7. **Advance Time**: Increment tick counter

Tick Timing
-----------

- 1 tick = 1 simulation time unit
- 60 ticks = 1 simulation minute (by convention)
- Real-time execution controlled by ``tick_rate`` config

Action Execution
----------------

Actions can be:

- **Instant**: Complete in 1 tick (e.g., MoveAction)
- **Progressive**: Take multiple ticks (e.g., GatherAction)
- **Interruptible**: Can be cancelled

Goal Management
---------------

Each agent maintains a priority queue of goals:

1. Evaluate all goals for utility
2. Select highest-utility achievable goal
3. Request next action from goal
4. Queue action for execution
5. Monitor goal completion

When goals complete or fail, agents re-evaluate.

System Updates
--------------

**Trading System**
   - Process pending trades
   - Expire old offers
   - Match buyers and sellers

**Respawn Manager**
   - Track dead entities
   - Spawn entities after delay
   - Place in safe zones

**Market**
   - Update prices based on trades
   - Calculate supply/demand

Database Persistence
--------------------

Snapshots saved at intervals:

- Agent state (position, health, inventory)
- World state (resource levels, active entities)
- Analytics metrics (economy, social networks)

All actions and events logged for analysis.
