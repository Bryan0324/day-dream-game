# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Godot 4.5 game project called "DayDream_game" that implements a hybrid board game combining Chinese Chess (Xiangqi) and Western Chess pieces on a single 16x16 grid board. The project is primarily written in GDScript with Chinese comments and includes a functional game interface with main menu navigation.

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
   - `Main.tscn` + `Main.gd`: Entry point with play/quit functionality
   - `scenes/boards/Board.tscn` + `board.gd`: Core game board with 16x16 grid system, player interaction, and turn management
   - `scenes/boards/highlight_layer.gd`: Manages move highlighting and click detection for valid moves
   - `scenes/boards/pieces_container.gd`: Container for all game pieces
   - `scenes/pieces/`: Complete piece implementations for both game types
   - `scenes/pieces/Light.tscn`: Individual highlight square used by highlight system

### Board System

The board (`scenes/boards/board.gd`) implements:
- 16x16 grid system using `GRID_COLS` and `GRID_ROWS` constants
- Automatic viewport scaling and positioning
- Coordinate conversion between grid positions and world positions via `grid_to_world()` and `world_to_grid()`
- Piece spawning system with automatic sprite scaling
- 2D board state array tracking piece positions
- Interactive piece selection and movement system
- Turn-based gameplay with `now_trun_chess` boolean (true = Western chess turn, false = Chinese chess turn)
- Move validation through `check_legal()` and `check_board()` helper functions
- Visual feedback system with highlight layer for valid moves

### Piece System

Pieces are organized by game type:
- `scenes/pieces/xiangqi/`: Chinese chess pieces (bing.gd, che.gd, ma.gd, xiang.gd, shih.gd, shuai.gd, pao.gd)
- `scenes/pieces/chess/`: Western chess pieces (pawn.gd, castle.gd, knight.gd, bishop.gd, queen.gd, king.gd)

All piece scripts are fully implemented with complete move logic.

Each piece extends Node2D and implements:
- `position_grid`: Grid-based position tracking
- `piece_owner`: Identifies which game system the piece belongs to ("chess" or "xiangqi")
- `_get_valid_moves()`: Returns [attack_moves, peaceful_moves] as Array containing two arrays
- `killing`: Boolean flag for special move types
- `origin`: Reference to original scene path for respawning
- Automatic positioning via parent board's grid system
- Board reference via `@onready var board = get_node("../../")` pattern

### Highlight System

The highlight layer (`scenes/boards/highlight_layer.gd`) implements:
- Visual feedback for valid moves using Light.tscn instances
- Separate handling for attack moves (moves[0]) and peaceful moves (moves[1])
- Click detection on highlighted squares to execute moves
- Automatic cleanup when moves are made or selection changes

### Asset Organization

- `assets/boards/`: Board textures and materials
- `assets/pieces/chess/`: Western chess piece sprites
- `assets/pieces/xiangqi/`: Chinese chess piece sprites

## Key Technical Notes

- The project uses Godot 4.5's new syntax including `@onready`, `@export`, and typed Arrays
- Grid coordinates start at (0,0) and use Vector2i for integer precision
- The board auto-scales to fit the viewport with 30px margins
- Piece sprites are automatically scaled to fit grid tiles with 1.5x scale factor
- Chinese text comments are used throughout the codebase
- Turn management: `now_trun_chess` boolean controls which player can move
- Move validation: Pieces return moves as [attack_moves, peaceful_moves] arrays
- Game uses Area2D input detection with signal binding for piece interaction
- Chinese chess pieces have special positioning logic (river crossing, palace restrictions)
- Coordinate system: Even-numbered grid positions for piece placement (pieces move by 2 grid units)
- The project.godot file contains merge conflict markers that should be resolved

## Critical Implementation Details

- **Board State Array**: `board_state[x][y]` tracks piece positions with `null` for empty squares
- **Move Validation**: Use `board.check_legal(pos)` for boundary checks and `board.check_board(pos)` for occupancy
- **Piece Spawning**: `_spawn_piece()` handles instantiation, positioning, scaling, and Area2D signal binding
- **Turn System**: Only pieces matching `now_trun_chess` can be selected (true = chess, false = xiangqi)
- **Highlight Interaction**: Clicking highlighted squares calls `board._move_piece()` to execute moves

## Current Implementation Status

Functional game implementation with:
- Complete board rendering and grid system ✓
- Full piece placement system for both game types ✓
- Interactive piece selection and movement ✓
- Turn-based gameplay with visual feedback ✓
- Chinese chess pieces with special rules (river crossing for Bing) ✓
- Western chess pieces with move validation ✓
- Main menu navigation (Play/Quit functionality) ✓
- Move highlighting system ✓
- Game managers exist but are largely empty templates (expansion points)

## File Naming Conventions

- Scene files use PascalCase: `Board.tscn`, `Pawn.tscn`
- Script files use snake_case: `board.gd`, `pawn.gd`
- Asset files use descriptive names with game prefixes where applicable