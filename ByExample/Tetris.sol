// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @dev Goal: A single-player Tetris game where each player has their own instance, with moves recorded on-chain.
/// Design:
/// Tetriminos: Seven types (I, O, T, S, Z, J, L) with rotations.
/// Mechanics: Players choose rotation and position for each Tetrimino, submit a transaction, and the contract updates the state.
contract Tetris {
    // Game state struct
    struct Game {
        // Flattened grid to uint8[200] (instead of uint8[20][10], 0 = empty, 1-7 = Tetrimino) to reduce gas costs by simplifying array access
        uint8[200] grid;
        uint8 currentType; // 0-6 for I, O, T, S, Z, J, L
        uint256 score;
        bool gameOver;
    }

    mapping(address => Game) public games;

    // Events for frontend: Emit updates for the grid, score, and game status.
    event GameStarted(address player);
    event TetriminoPlaced(address player, uint8 tp, uint256 score);
    event LineCleared(address player, uint256 lines, uint256 newScore);
    event GameOver(address player, uint256 finalScore);

    /// Defining Tetrimino Shapes
    /// Reduced redundancy (e.g., I and S/Z have 2 rotations).
    /// Returns dr (row offsets) and dc (column offsets) for each block.
    /// We’ll store Tetrimino shapes efficiently. Each Tetrimino has four blocks, defined by offsets from a pivot point. For gas efficiency, we’ll use a single function with packed data:
    function getShape(
        uint8 tp,
        uint8 rot
    ) internal pure returns (int8[4] memory dr, int8[4] memory dc) {
        if (tp == 0) {
            // I
            rot = rot % 2; // Only 2 unique rotations
            return
                rot == 0
                    ? ([int8(0), 0, 0, 0], [int8(-1), 0, 1, 2])
                    : ([int8(-1), 0, 1, 2], [int8(0), 0, 0, 0]);
        } else if (tp == 1) {
            // O
            return ([int8(0), 0, 1, 1], [int8(0), 1, 0, 1]); // No rotation
        } else if (tp == 2) {
            // T
            if (rot == 0) return ([int8(-1), 0, 0, 0], [int8(0), -1, 0, 1]);
            if (rot == 1) return ([int8(-1), 0, 0, 1], [int8(0), 0, 1, 0]);
            if (rot == 2) return ([int8(0), 0, 0, 1], [int8(-1), 0, 1, 0]);
            return ([int8(-1), 0, 0, 1], [int8(0), -1, 0, 0]);
        } else if (tp == 3) {
            // S
            rot = rot % 2;
            return
                rot == 0
                    ? ([int8(0), 0, 1, 1], [int8(-1), 0, 0, 1])
                    : ([int8(-1), 0, 0, 1], [int8(0), 0, 1, 1]);
        } else if (tp == 4) {
            // Z
            rot = rot % 2;
            return
                rot == 0
                    ? ([int8(0), 0, 1, 1], [int8(0), 1, -1, 0])
                    : ([int8(-1), 0, 0, 1], [int8(1), 1, 0, 0]);
        } else if (tp == 5) {
            // J
            if (rot == 0) return ([int8(-1), 0, 0, 0], [int8(0), -1, 0, 1]);
            if (rot == 1) return ([int8(-1), -1, 0, 1], [int8(0), 1, 0, 0]);
            if (rot == 2) return ([int8(0), 0, 0, 1], [int8(-1), 0, 1, 0]);
            return ([int8(-1), 0, 1, 1], [int8(0), 0, -1, 0]);
        } else {
            // L (tp == 6)
            if (rot == 0) return ([int8(-1), 0, 0, 0], [int8(0), -1, 0, 1]);
            if (rot == 1) return ([int8(-1), 0, 0, 1], [int8(0), 0, 1, 0]);
            if (rot == 2) return ([int8(0), 0, 0, 1], [int8(-1), 0, 1, -1]);
            return ([int8(-1), 0, 0, 1], [int8(-1), 0, -1, 0]);
        }
    }

    /// Check if a Tetrimino fits at a given position:
    function isValidPosition(
        Game storage game,
        uint8 tp,
        uint8 rot,
        uint8 row,
        uint8 col
    ) internal view returns (bool) {
        (int8[4] memory dr, int8[4] memory dc) = getShape(tp, rot);
        for (uint i = 0; i < 4; i++) {
            int16 r = int16(uint16(row)) + int16(dr[i]);
            int16 c = int16(uint16(col)) + int16(dc[i]);
            if (r < 0 || r >= 20 || c < 0 || c >= 10) {
                return false;
            }

            uint index = _safeConvertInt16ToUint256(r) *
                10 +
                uint(_safeConvert(c));
            if (game.grid[index] != 0) {
                return false;
            }
        }
        return true;
    }

    // 安全轉換函數（帶範圍檢查）
    function _safeConvert(int16 _input) private pure returns (uint8) {
        require(_input >= 0, "Negative value cannot convert to uint8");
        require(_input <= 255, "Value exceeds uint8 maximum");
        return uint8(uint16(_input)); // 分步轉換
    }

    function _safeConvertUint8ToInt16(
        uint8 _input
    ) private pure returns (int16) {
        // 步骤 1：uint8 → uint16（隐式或显式均可）
        uint16 intermediate = _input; // 隐式转换（因为 uint8 < uint16）

        // 步骤 2：uint16 → int16（显式转换）
        return int16(intermediate);
    }

    // 安全转换（分步显式转换）
    function _safeConvertInt16ToUint256(
        int16 _input
    ) private pure returns (uint256) {
        require(_input >= 0, "Negative value invalid for uint256");
        return uint256(uint16(_input));
    }

    function startGame() public {
        Game storage game = games[msg.sender];
        for (uint i = 0; i < 200; i++) {
            game.grid[i] = 0;
        }
        game.score = 0;
        game.gameOver = false;
        game.currentType = uint8(
            uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 7
        );
        emit GameStarted(msg.sender);
    }

    /// Placing Tetriminos and Game Logic
    function placeTetrimino(uint8 rotations, int8 horizontalMove) public {
        Game storage game = games[msg.sender];
        require(!game.gameOver, "Game over");

        uint8 rot = rotations % 4;
        (int8[4] memory dr, int8[4] memory dc) = getShape(
            game.currentType,
            rot
        );

        // Starting position
        int8 min_dr = 0;
        for (uint i = 0; i < 4; i++) {
            if (dr[i] < min_dr) min_dr = dr[i];
        }
        uint8 row = min_dr < 0 ? uint8(-min_dr) : 0;
        int8 col = 4 + horizontalMove; // Center at col 4

        // Check if game ends
        if (!isValidPosition(game, game.currentType, rot, row, uint8(col))) {
            game.gameOver = true;
            emit GameOver(msg.sender, game.score);
            return;
        }

        // Drop Tetrimino
        while (
            row < 19 &&
            isValidPosition(game, game.currentType, rot, row + 1, uint8(col))
        ) {
            row++;
        }

        // Place Tetrimino
        for (uint i = 0; i < 4; i++) {
            uint8 r = _safeConvert(_safeConvertUint8ToInt16(row) + dr[i]);
            uint8 c = _safeConvert(col + dc[i]);
            game.grid[r * 10 + c] = game.currentType + 1;
        }
        emit TetriminoPlaced(msg.sender, game.currentType, game.score);

        // Clear lines
        uint linesCleared = 0;
        uint8[200] memory tempGrid;
        uint destIdx = 190; // Start from bottom (19 * 10)
        for (uint8 r = 19; r < 20; r--) {
            // Iterate bottom-up
            bool full = true;
            for (uint8 c = 0; c < 10; c++) {
                if (game.grid[r * 10 + c] == 0) {
                    full = false;
                    break;
                }
            }
            if (full) {
                linesCleared++;
            } else {
                for (uint8 c = 0; c < 10; c++) {
                    tempGrid[destIdx + c] = game.grid[r * 10 + c];
                }
                destIdx -= 10;
            }
        }
        if (linesCleared > 0) {
            game.score += linesCleared * 40; // Simple scoring
            for (uint i = 0; i < 200; i++) {
                game.grid[i] = tempGrid[i];
            }
            emit LineCleared(msg.sender, linesCleared, game.score);
        }

        // Next Tetrimino
        game.currentType = uint8(
            uint(
                keccak256(
                    abi.encodePacked(block.timestamp, msg.sender, game.score)
                )
            ) % 7
        );
    }
}
