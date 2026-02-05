# Copilot Instructions

- This repository is an Arma 3 mod.
- All scripts are SQF unless stated otherwise.
- Prefer scheduled environments where possible.
- Avoid using sleep in unscheduled code.
- Use private variables.
- Do not introduce UTF-8 BOM.
- Paths must respect Arma mod prefixes (z\my_mod\addons\main).
- Avoid using deprecated commands and features.
- Avoid using commands that are known to cause performance issues.
- Avoid using commands that are known to cause synchronization issues in multiplayer.
- Avoid using commands that are known to cause issues with the Arma 3 engine.
- Prefer engine commands over scripted loops.
- Avoid using global variables.
- Use descriptive variable and function names.
- Follow the existing code style and conventions.
- Document functions with comments explaining their purpose and parameters.
- Test changes in a controlled environment before committing with hemtt check
- Ensure compatibility with the latest Arma 3 version (2.20).
- ACE3 is a dependency, so ensure compatibility with the latest ACE3 version (v2.14.0) as well as any relevant ACE3 modules.
- Avoid using features that are known to cause issues with ACE3.
- Ensure that any new features or changes do not break existing functionality.
- Follow best practices for performance optimization in Arma 3 scripting.
- Do not introduce UTF-8 BOM.
- Encode in UTF-8 without BOM.
- Use CRLF line endings.

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
