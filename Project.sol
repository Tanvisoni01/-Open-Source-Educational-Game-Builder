// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OpenSourceEducationalGameBuilder {

    struct Game {
        uint256 id;
        string name;
        string description;
        address creator;
        uint256 creationTime;
        string gameContentURI;  // Link to the game assets or code (IPFS)
    }

    uint256 public gameCount;
    mapping(uint256 => Game) public games;
    mapping(address => uint256[]) public userGames;

    event GameCreated(uint256 indexed gameId, address indexed creator, string name, string description, uint256 creationTime, string gameContentURI);

    // Modifier to ensure the caller is the creator of the game
    modifier onlyCreator(uint256 gameId) {
        require(games[gameId].creator == msg.sender, "Not the creator of this game");
        _;
    }

    // Constructor
    constructor() {
        gameCount = 0;
    }

    // Function to create a new game
    function createGame(string memory _name, string memory _description, string memory _gameContentURI) public {
        gameCount++;
        uint256 gameId = gameCount;

        Game memory newGame = Game({
            id: gameId,
            name: _name,
            description: _description,
            creator: msg.sender,
            creationTime: block.timestamp,
            gameContentURI: _gameContentURI
        });
        

        games[gameId] = newGame;
        userGames[msg.sender].push(gameId);

        emit GameCreated(gameId, msg.sender, _name, _description, block.timestamp, _gameContentURI);
    }

    // Function to get a list of games created by a user
    function getUserGames(address _user) public view returns (uint256[] memory) {
        return userGames[_user];
    }

    // Function to update game content (only by creator)
    function updateGameContent(uint256 gameId, string memory _newContentURI) public onlyCreator(gameId) {
        games[gameId].gameContentURI = _newContentURI;
    }

    // Function to get game details by ID
    function getGameDetails(uint256 gameId) public view returns (Game memory) {
        return games[gameId];
    }

    // Function to delete a game (only by creator)
    function deleteGame(uint256 gameId) public onlyCreator(gameId) {
        delete games[gameId];
    }
}
