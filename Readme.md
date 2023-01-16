Three Contracts 

** 1. KeyGeneration**
This  contract called "KeyGeneration" implements a basics of the DKG protocol.
The contract allows players to register with the contract and submit their secret number, then it generates a shared public key using the sum of the submitted numbers and threshold value, after generating the shared public key using the sum of the numbers and threshold value, it uses this shared public key along with the player's number to generate the player's individual public key and private key using the ElGamal encryption.

** 2. GameServer**
Approves Players to the game using ElGamal encryption to verify the seed and public keys generated from _KeyGeneration_, and then use Schnorr signatures and a 
Distributed Key Generation (DKG) protocol to approve the public key for use in a game 

Also controls game logic
functions like
-Shuffling the cards and encrypting them using the shared public key and the players' secret key shares.
-Sending the encrypted cards to the players and receiving their actions.
-Verifying the players' actions and updating the game state in the smart contract.
-Sending the updated game state to the players and receiving their seed
-verification and collision checking




** 3. CardGame**

This contract keeps track of the approved players and their public keys, seeds and the game state, it has a approvePlayer function which is called by the GameServer contract to approve a player, this function stores the player's public key, seed and pushes the player's address to the players array.
Receives the player's address as an argument, it first checks that the player has been approved. Then it checks if the player is allowed to reveal their seed, if they are allowed to do so the function assigns the seed of the player to variable seed, Finally, it sends the seed to the designated parties.

It also has an updateGameState function which is called by the game server contract to update the game state based on the player's action.

It also has a sendEncryptedCards function which is called by the game server contract to send the encrypted cards to the player.



**Addresses of Deployed Contracts**

