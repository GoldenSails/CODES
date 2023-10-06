// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract SwapContract {
    address public owner;
    IERC20 public tokenA;
    IERC20 public tokenB;
    address public poolAddress;

    constructor(address _ship, address _qship, address _poolAddress) {
        owner = msg.sender;
        tokenA = IERC20(_ship);
        tokenB = IERC20(_qship);
        poolAddress = _poolAddress;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    function depositTokenA(uint256 amount) external {
        require(tokenA.transferFrom(msg.sender, poolAddress, amount), "Transfer of Token A failed");
        require(tokenB.transfer(msg.sender, amount), "Transfer of Token B to sender failed");
    }

    function withdrawTokenA(uint256 amount) external {
        require(tokenB.transferFrom(msg.sender, poolAddress, amount), "Transfer of Token B failed");
        require(tokenA.transfer(msg.sender, amount), "Transfer of Token A to sender failed");
    }

    // Allows the owner to withdraw excess tokens (for any reason)
    // function rescueExcessTokens(address token, address to, uint256 amount) external onlyOwner {
    //    IERC20(token).transfer(to, amount);
    //}
}
