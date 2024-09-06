// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, ERC20Burnable, Ownable {

    mapping(uint256 => uint256) private marketValue;
    mapping(address => string[]) private redeemedItems;

    event TokensMinted(address indexed to, uint256 amount);
    event TokensRedeemed(address indexed by, uint256 choice, uint256 amount);
    event TokensBurned(address indexed by, uint256 amount);
    event TokensTransferred(address indexed from, address indexed to, uint256 amount);

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        marketValue[1] = 99;
        marketValue[2] = 49;  
        marketValue[3] = 19;  
    }

    function mintDegen(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    function burnToken(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount);
    }

    function transferTokensTo(address _receiver, uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        transfer(_receiver, amount);
        emit TokensTransferred(msg.sender, _receiver, amount);
    }

    function getDegenBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function gameStore() public pure returns (string[] memory) {
        string[] memory items = new string[](3);
        items[0] = "1. Character Maya = 99";
        items[1] = "2. Thunderbolt Weapon = 49";
        items[2] = "3. Vandefer Companion = 19";
        return items;
    }

    function redeemTokens(uint256 choice) external {
        require(choice >= 1 && choice <= 3, "Invalid selection");

        uint256 amountToRedeem = marketValue[choice];
        require(amountToRedeem > 0, "Invalid choice");

        require(balanceOf(msg.sender) >= amountToRedeem, "Insufficient balance");
        
        // Burn the tokens instead of transferring
        _burn(msg.sender, amountToRedeem);

        // Add redeemed item to the user's list
        if (choice == 1) {
            redeemedItems[msg.sender].push("Character Maya");
        } else if (choice == 2) {
            redeemedItems[msg.sender].push("Thunderbolt Weapon");
        } else if (choice == 3) {
            redeemedItems[msg.sender].push("Vandefer Companion");
        }

        emit TokensRedeemed(msg.sender, choice, amountToRedeem);
    }

    function getRedeemedItems() external view returns (string[] memory) {
        return redeemedItems[msg.sender];
    }
}
