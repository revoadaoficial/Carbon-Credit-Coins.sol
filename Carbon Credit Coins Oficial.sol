// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract CarbonCreditCoin is ERC20, Ownable, Pausable {
    uint256 public constant MAX_SUPPLY = 20_000_000_000 * 10**18;

    address public treasury;
    address public operator;
    bool public mintingLocked;

    mapping(address => bool) public authorized;

    event TreasuryUpdated(address indexed previousTreasury, address indexed newTreasury);
    event OperatorUpdated(address indexed previousOperator, address indexed newOperator);
    event AuthorizedSet(address indexed account, bool allowed);
    event MintingLocked();

    modifier onlyAuthorized() {
        require(
            msg.sender == owner() || msg.sender == operator || authorized[msg.sender],
            "Not authorized"
        );
        _;
    }

    constructor(
        address masterOwner,
        address initialTreasury,
        address initialOperator
    ) ERC20("Carbon Credit Coins", "CCC") Ownable(masterOwner) {
        require(masterOwner != address(0), "Invalid owner");
        require(initialTreasury != address(0), "Invalid treasury");
        require(initialOperator != address(0), "Invalid operator");

        treasury = initialTreasury;
        operator = initialOperator;

        _mint(initialTreasury, MAX_SUPPLY);
    }

    function setTreasury(address newTreasury) external onlyOwner {
        require(newTreasury != address(0), "Invalid treasury");
        address previous = treasury;
        treasury = newTreasury;
        emit TreasuryUpdated(previous, newTreasury);
    }

    function setOperator(address newOperator) external onlyOwner {
        require(newOperator != address(0), "Invalid operator");
        address previous = operator;
        operator = newOperator;
        emit OperatorUpdated(previous, newOperator);
    }

    function setAuthorized(address account, bool allowed) external onlyOwner {
        authorized[account] = allowed;
        emit AuthorizedSet(account, allowed);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function lockMinting() external onlyOwner {
        mintingLocked = true;
        emit MintingLocked();
    }

    function rescueForeignToken(address token, uint256 amount) external onlyOwner {
        require(token != address(this), "Cannot rescue CCC");
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSignature("transfer(address,uint256)", treasury, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "Rescue failed");
    }

    function _update(address from, address to, uint256 value)
        internal
        override
        whenNotPaused
    {
        super._update(from, to, value);
    }
Ã, e esse aqui que eu tÃ´ te mandando, que que Ã©?
