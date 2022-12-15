// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";


/// @title Coin flip coding challenge
/// @author Taylor Ferran
/// @notice A contract which allows a user to wager some matic and 
/// call coinFlip, if the contract contains at least double what 
/// the user has wagered, they have a 51.1% chance of receiving 
/// that and a 49.9% chance of receiving nothing.
/// @dev We use a LINK api call to generate true randomness to protect 
/// the game from miner manipulation, downside is we must keep this
/// contract topped up with link and only one game can be played at a time.

contract CoinFlip is VRFConsumerBase {

    /// @dev This number is 49.9% of the uint256 max value
    uint256 immutable FortyNinePointNinePercent = 57780252529420781516361921519335266018781722348154641455689334419948651690328;

    // Variables to be kept in storage whilst the link call is fulfilled
    bool flipActive;
    address playerAddress;
    uint256 wager;

    // Public variables to check the last game played
    uint256 public previousGameReturnedRandomNumber;
    // true is a win, false is a loss
    bool public previousGameOutCome;

    bytes32 immutable keyHash;
    uint256 immutable fee;

    // Normally we would deploy with passing the contstructor variables in, but I've left 
    // them in incase whoever looks at this is curious to what was used
    constructor()
    VRFConsumerBase(0x8C7382F9D8f56b33781fE506E897a4F1e2d17255, 0x326C977E6efc84E512bB9C30f76E30c160eD06FB) {
        keyHash = 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4;
        fee = 100000000000000;
    }

    /// @notice Player will call this function to play the game, sending an amount of
    /// matic greater than zero and less than the amount they can possibly win
    function coinFlip() public payable {
        require(msg.value  <= address(this).balance, "Not enough matic in contract to play");
        require(!flipActive, "Game currently active");
        require(msg.value > 0);
        // Set values in storage for when link api call fulfills
        flipActive = true;
        playerAddress = msg.sender;
        wager = msg.value;
        getRandomNumber();
    }

    /// @notice Called after receiving our random number to settle the game
    /// @param _requestId is the link request id, unused here
    /// @param _randomNumber is the uint256 returned by the link api call
    function fulfillRandomness(bytes32 _requestId, uint256 _randomNumber) internal virtual override  {

        if(_randomNumber <= FortyNinePointNinePercent) {
            (bool sent,) = playerAddress.call{value: wager*2}("");
            previousGameOutCome = true;
        }

        previousGameReturnedRandomNumber = _randomNumber;

        // Reset game
        flipActive = false;
        playerAddress = address(0);
        wager = 0;
    }

    /// @notice Link call to vrf coordinator to get a random uint256
    function getRandomNumber() private returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough link in contract to play");
        return requestRandomness(keyHash, fee);
    }

    receive() external payable {}
    fallback() external payable {}

}
