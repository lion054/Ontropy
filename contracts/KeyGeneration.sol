// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/cryptography/ElGamalEncryption.sol";


contract KeyGeneration {
    struct Player {
        address addr;
        uint share;
        bytes32 publicKey;
        bytes32 privateKey;
    }
    mapping(address => Player) public players;
    uint public threshold;

    function registerPlayer(uint _threshold) public {
        require(_threshold > 0, "Invalid threshold");
        require(players[msg.sender].addr == address(0), "Player already registered");
        threshold = _threshold;
        players[msg.sender].addr = msg.sender;
    }

    function submitShare(uint _share) public {
        require(_share <= 100, "Invalid share, share should be less than or equal to 100");
        require(players[msg.sender].addr != address(0), "Player not registered");
        players[msg.sender].share = _share;
    }

    require(sum <= 100, "Invalid sum, sum of shares should be less than or equal to 100");

    
    function generateKey() public view returns (bytes32) {
        require(players[msg.sender].share != 0, "Player share not submitted");
        uint count = 0;
        uint sum = 0;
        if (players[player].addr != address(0) && players[player].share != 0) {
    count++;
    sum += players[player].share;
}

        for (address player in players) {
            if (players[player].share != 0) {
                count++;
                sum += players[player].share;
            }
        }
        require(count >= threshold, "Not enough players");
        bytes32 sharedPublicKey = sha256(abi.encodePacked(sum));
        for (address player in players) {
            if (players[player].share != 0) {
                players[player].publicKey = ElGamalEncryption.generatePublicKey(sharedPublicKey, players[player].share);
                players[player].privateKey = ElGamalEncryption.generatePrivateKey(players[player].share);
            }
        }
        return sharedPublicKey;
    }
}
