// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.9;

import './interfaces/IXXXFactory.sol';
import './XXXFund.sol';

contract XXXFactory is IXXXFactory {
    address public override owner;

    /// @notice Emitted when the owner of the factory is changed
    /// @param oldOwner The owner before the owner was changed
    /// @param newOwner The owner after the owner was changed
    event OwnerChanged(address indexed oldOwner, address indexed newOwner);

    mapping(address => address) public getFund;
    uint public totalFunds;

    event FundCreated(address manager, address fund, uint totalFunds);

    constructor() {
        owner = msg.sender;
        totalFunds = 0;
        emit OwnerChanged(address(0), msg.sender);
    }

    function createFund(address manager, address token, uint amount) external returns (address fund) {
        require(manager == msg.sender, 'XXXFactory: IDENTICAL_ADDRESSES');
        require(manager != address(0), 'XXXFactory: ZERO_ADDRESS');
        require(getFund[manager] == address(0), 'XXXFactory: FUND_EXISTS'); // single check is sufficient
        require(token != address(0), 'XXXFactory: INVALID_TOKEN_ADDRESS');
        fund = address(new XXXFund{salt: keccak256(abi.encode(address(this), manager))}());
        IXXXFund(fund).initialize(manager, token, amount);
        getFund[manager] = fund; // populate mapping in the reverse direction
        totalFunds += 1;
        emit FundCreated(manager, fund, totalFunds);
    }

    function setOwner(address _owner) external override {
        require(msg.sender == owner);
        emit OwnerChanged(owner, _owner);
        owner = _owner;
    }
}