# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Godot 4.5 game project called "DayDream_game" that implements a hybrid board game combining Chinese Chess (Xiangqi) and Western Chess pieces on a single 16x16 grid board. The project is primarily written in GDScript with Chinese comments.

## Development Commands

Since this is a Godot project, development is typically done through the Godot Editor:

- **Run the game**: Open project.godot in Godot Editor and press F5 or click the Play button
- **Edit scenes**: Use the Godot Editor's Scene dock
- **Debug**: Use Godot's built-in debugger (F6 for debug mode)

No traditional build commands like npm or make are used - Godot handles compilation internally.

## Architecture

### Core System Architecture

The game uses Godot's scene-node architecture with the following key components:

1. **Autoloads (Singletons)**:
   - `autoloads/game_manager.gd`: Global game state management (currently minimal)
   - `autoloads/rule_manager.gd`: Game rules and logic (currently minimal)
   - `autoloads/asset_manager.gd`: Asset loading and management

2. **Main Game Structure**:
   - `Main.tscn`: Entry point scene
   - `scenes/boards/Board.tscn` + `board.gd`: Core game board with 16x16 grid system
   - `scenes/pieces/`: Piece implementations split by game type

### Board System

The board (`scenes/boards/board.gd`) implements:
- 16x16 grid system using `GRID_COLS` and `GRID_ROWS` constants
- Automatic viewport scaling and positioning
- Coordinate conversion between grid positions and world positions via `grid_to_world()` and `world_to_grid()`
- Piece spawning system with automatic sprite scaling
- 2D board state array tracking piece positions

### Piece System

Pieces are organized by game type:
- `scenes/pieces/xiangqi/`: Chinese chess pieces (兵/Bing implemented)
- `scenes/pieces/chess/`: Western chess pieces (Pawn implemented)

Each piece extends Node2D and implements:
- `position_grid`: Grid-based position tracking
- `piece_owner`: Identifies which game system the piece belongs to
- `get_moves()`: Returns valid moves as Array[Vector2i]
- Automatic positioning via parent board's grid system

### Asset Organization

- `assets/boards/`: Board textures and materials
- `assets/pieces/chess/`: Western chess piece sprites
- `assets/pieces/xiangqi/`: Chinese chess piece sprites (referenced but may need implementation)

## Key Technical Notes

- The project uses Godot 4.5's new syntax including `@onready`, `@export`, and typed Arrays
- Grid coordinates start at (0,0) and use Vector2i for integer precision
- The board auto-scales to fit the viewport with 30px margins
- Piece sprites are automatically scaled to fit grid tiles with 1.5x scale factor
- Chinese text comments are used throughout the codebase
- The project.godot file contains merge conflict markers that should be resolved

## Current Implementation Status

This appears to be an early-stage implementation with:
- Basic board rendering and grid system ✓
- Basic piece placement system ✓
- Chinese chess Bing (兵) piece with river-crossing logic ✓
- Western chess Pawn piece ✓
- Game managers exist but are largely empty templates
- No player input handling or game flow implemented yet

## File Naming Conventions

- Scene files use PascalCase: `Board.tscn`, `Pawn.tscn`
- Script files use snake_case: `board.gd`, `pawn.gd`
- Asset files use descriptive names with game prefixes where applicable