// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Account {
    mapping(address => uint) public balances;
    uint public deposits;

    modifier sufficientBalance(uint _amt) {
        require(balances[msg.sender] >= _amt, "ERROR");
    _;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        deposits += msg.value;
    }

    function withdraw(uint _amt) public sufficientBalance(_amt) {
        assert(address(this).balance >= _amt);
        balances[msg.sender] -= _amt;
        deposits -= _amt;
        (bool success, ) = msg.sender.call{value: _amt}("");
        require(success, "Not able to transfer");
    }

    function transfer(address _recpt, uint _amt) public sufficientBalance(_amt){
        if (_recpt == address(12)) {
            revert("Address Not Found");
        }
        balances[msg.sender] -= _amt;
        balances[_recpt] += _amt;
    }
}