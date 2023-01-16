// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/cryptography/SchnorrVerifier.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/cryptography/ElGamalEncryption.sol";

contract GameServer {
    using SafeMath for uint;
    address public cardGameAddress;
    mapping(address => bytes32) public playerSeed;
    mapping(address => bytes32) public playerPublicKey;
    mapping(address => bool) public playerApproved;

    constructor(address _cardGameAddress) public {
        cardGameAddress = _cardGameAddress;
    }

    function verifySeedAndPublicKey(address _player, bytes32 _seed, bytes32 _publicKey) public {
        require(players[_player].addr == _player, "Player not registered");
        bytes32 sharedPublicKey = KeyGeneration(cardGameAddress).getSharedPublicKey();
        require(ElGamalEncryption.verifyPublicKey(_publicKey, sharedPublicKey, players[_player].share), "Invalid public key");
        require(SchnorrVerifier.verifySignature(_seed, _publicKey), "Invalid seed");
        playerSeed[_player] = _seed;
        playerPublicKey[_player] = _publicKey;
        playerApproved[_player] = true;
    }

    function approvePlayer(address _player) public {
        require(players[_player].addr == _player, "Player not registered");
        require(playerApproved[_player], "Player not verified");
        CardGame(cardGameAddress).approvePlayer(_player, playerPublicKey[_player]);
    }

        function shuffleCards() internal returns (bytes32) {
        // Shuffle the cards here
        // ...

        // Encrypt the shuffled cards using ElGamal encryption
        bytes32 sharedPublicKey = KeyGeneration(cardGameAddress).getSharedPublicKey();
        return ElGamalEncryption.encrypt(shuffledCards, sharedPublicKey);
    }


    function encryptCards(address _player) public {
        require(playerApproved[_player], "Player not approved");
        bytes32 sharedPublicKey = KeyGeneration(cardGameAddress).getSharedPublicKey();
        bytes32 encryptedCards = ElGamalEncryption.encrypt(shuffleCards(), sharedPublicKey, playerSeed[_player]);
        CardGame(cardGameAddress).sendEncryptedCards(_player, encryptedCards);
    }

        function verifyPlayerAction(address _player, bytes _action) public {
        // Verify the player's action here
        bytes32 sharedPublicKey = KeyGeneration(cardGameAddress).getSharedPublicKey();
        require(ElGamalEncryption.verify(playerSeed[_player], _action, sharedPublicKey), "Invalid action");
        // Check for collision with other players' actions
        for (address otherPlayer in playerApproved) {
            if (otherPlayer != _player && playerActions[otherPlayer] == _action) {
                require(false, "Collision detected");
            }
        }
        playerActions[_player] = _action;
    }

        function playCard(address _player, bytes _action) public {
        require(playerApproved[_player], "Player not approved");
        verifyPlayerAction(_player, _action);
        updateGameState(_player, _action);
        // Send response back to player
        // ...
         }



        function updateGameState(address _player, bytes _action) public {
        require(playerApproved[_player], "Player not approved");
        require(playerActions[_player] == _action, "Invalid action");
        // Update the game state here
        CardGame(cardGameAddress).updateGameState(_player, _action);
    }
