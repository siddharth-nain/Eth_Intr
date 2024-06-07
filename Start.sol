// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ElectricityBilling {
    address public owner;
    uint public freeUnits = 200;
    uint public ratePerUnit;

    mapping(address => uint) public usage;
    mapping(address => uint) public bills;

    event BillPaid(address indexed user, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor(uint _ratePerUnit) {
        require(_ratePerUnit > 0, "Rate per unit must be greater than zero");
        owner = msg.sender;
        ratePerUnit = _ratePerUnit;
    }

    function recordUsage(address user, uint units) external onlyOwner {
        require(units > 0, "Usage must be greater than zero");

        usage[user] += units;
    }

    function calculateBill(address user) external onlyOwner returns (uint) {
        uint totalUnits = usage[user];
        require(totalUnits > 0, "No usage recorded for this user");

        if (totalUnits <= freeUnits) {
            bills[user] = 0;
        } else {
            uint chargeableUnits = totalUnits - freeUnits;
            bills[user] = chargeableUnits * ratePerUnit;
        }

        assert(bills[user] >= 0); 
        return bills[user];
    }

    function payBill() external payable {
        uint billAmount = bills[msg.sender];
        require(billAmount > 0, "No bill due");
        require(msg.value == billAmount, "Incorrect bill amount");

        bills[msg.sender] = 0;
        emit BillPaid(msg.sender, msg.value);
    }

    function withdraw() external onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "No funds available for withdrawal");
        payable(owner).transfer(balance);
    }

    function setRatePerUnit(uint _ratePerUnit) external onlyOwner {
        if (_ratePerUnit <= 0) {
            revert("New rate per unit must be greater than zero");
        }
        ratePerUnit = _ratePerUnit;
    }
}
