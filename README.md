# Lng


- Join Game 
- Start Game
- Up to 10 players in a room
    - Each player gets a guess then we move on to the next player?
- Each player is individual
- CSS animations for all the things
- Everyone that doesn't have a seat is just a spectator

- Target Word
    - IE "Friend"
- Current Guesses
    - "Folks"
    - "Freaks"

## Architecture

- Board.ex
    - Manages Board
        - Reset/0
        - Start_Link
        - Guess(pid, word)
    - Increments own turn after a time if guess is not correct



## Extras
- URL should identify room