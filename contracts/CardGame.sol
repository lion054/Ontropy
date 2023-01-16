// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "./GameServer.sol";


contract CardGame {
    address[] public players;
    mapping(address => bool) public playerApproved;
    mapping(address => bytes32) public playerPublicKey;
    mapping(address => bytes32) public playerSeed;
    address GameServerAddress = 0x1234567890abcdef;
    GameServer GameServer = GameServer(GameServerAddress);

    function approvePlayer(address _player, bytes32 _publicKey) public {
        require(msg.sender == address(GameServer), "Only GameServer contract can approve players");
        require(!playerApproved[_player], "Player already approved");require(_player != address(0), "Invalid address passed");
        
        playerSeed[_player] = GameServer(msg.sender).getPlayerSeed(_player);
        playerApproved[_player] = true;
        playerPublicKey[_player] = _publicKey;
        players.push(_player);
    }

        function startGame() public {
        require(msg.sender == address(GameServer), "Only GameServer can start the game");
        require(players.length > 0, "At least one player should be approved to start the game");

        // Shuffle the cards
        bytes32 shuffledCards = GameServer(msg.sender).shuffleCards();
        // Encrypt the shuffled cards
        for (uint i = 0; i < players.length; i++) {
            GameServer(msg.sender).encryptCards(players[i], shuffledCards);
        }
    }


    function updateGameState(address _player, bytes _action) public {
        require(playerApproved[_player], "Player not approved");
        require(_action.length == 32, "Invalid action");

        // Update game state based on player's action
        // ...
    }

        function revealSeed(address _player) public {
        require(playerApproved[_player], "Player not approved");
        // Check if player is allowed to reveal their seed
        // ...
        bytes32 seed = playerSeed[_player];
        // Send seed to designated parties
        // ...
    }


    function sendEncryptedCards(address _player, bytes32 _encryptedCards) public {
        require(playerApproved[_player], "Player not approved");
        // Send the encrypted cards to the player
        // ...
    }

        function showPlayerCard(address _player) public {
        require(playerApproved[_player], "Player not approved");
        // Verify that the player has picked a card
        // ...
        ElGamalCiphertext encryptedCard = playerCardsElGamal[_player];
        ElGamalPublicKey publicKey = playerPublicKeyElGamal[_player];
        ElGamalPrivateKeyShare privateKeyShare = playerPrivateKeyShareElGamal[_player];

        // Decrypt the card using ElGamal
        bytes32 m = powMod(encryptedCard.c2, privateKeyShare.x, publicKey.p);
        bytes32 plaintext = (encryptedCard.c1 * m) % publicKey.p;

        // Reveal the decrypted card to the other players or the game server
        // ...
    }

}
