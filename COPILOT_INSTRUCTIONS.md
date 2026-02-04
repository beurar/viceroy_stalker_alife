# Copilot Instructions & Guidelines

## SQF Best-practices
Always run hemtt check after making adjustments and ensure that there are no SQF errors, warnings, or unimplemented optimisations.

## Preventing Script Lockups (Max Script Time)
Arma 3 has a limit for how long a scheduled script can run in a single frame (3ms limit usually). Exceeding this or running heavy loops in unscheduled environment freezes the game.

### Rules:
1. **Loop Yielding**: Any loop that iterates more than 10-20 times OR does heavy work (like `nearestObjects`, `nearestTerrainObjects`, `lineIntersects`) **MUST** contain a yield.
   ```sqf
   private _counter = 0;
   {
       // ... logic ...
       _counter = _counter + 1;
       if (_counter % 10 == 0) then { sleep 0.001; }; // YIELD
   } forEach _largeArray;
   ```

2. **Sequential Spawning**: When spawning complex compositions (like camps), do **NOT** spawn everything in one frame. Spread it out.
   ```sqf
   // Bad
   { [] call spawnBigThing; } forEach _places;
   
   // Good
   { 
       [] call spawnBigThing; 
       sleep 0.1; 
   } forEach _places;
   ```

3. **Loop Termination**: Prefer finite loops or `for` loops counting down when modifying arrays or breaking.
   ```sqf
   for "_i" from (count _array - 1) to 0 step -1 do { ... };
   ```

4. **Background Checks**: Heavy spatial searches should be done in a spawned script `[] spawn { ... }` rather than `call`, unless non-blocking return is needed.
