// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserAccount {
    struct User {
        string username;
        bytes32 passwordHash;
    }

    mapping(address => User) private users;

    event UsernameChanged(address indexed user, string newUsername);

    modifier userExists(address _user) {
        require(users[_user].passwordHash != 0, "User does not exist");
        _;
    }

    function setUsername(string memory _username, string memory _password) public {
        require(bytes(_username).length > 0, "Username cannot be empty");
        require(bytes(_password).length > 0, "Password cannot be empty");

        bytes32 passwordHash = keccak256(abi.encodePacked(_password));
        users[msg.sender] = User(_username, passwordHash);

        // Ensure the user data is set correctly
        assert(users[msg.sender].passwordHash == passwordHash);
    }

    function changeUsername(string memory _newUsername, string memory _password) public userExists(msg.sender) {
        require(bytes(_newUsername).length > 0, "New username cannot be empty");
        require(bytes(_password).length > 0, "Password cannot be empty");

        User storage user = users[msg.sender];
        bytes32 passwordHash = keccak256(abi.encodePacked(_password));

        if (user.passwordHash != passwordHash) {
            revert("Incorrect password");
        }

        user.username = _newUsername;

        // Ensure the username was changed correctly
        assert(keccak256(abi.encodePacked(user.username)) == keccak256(abi.encodePacked(_newUsername)));

        emit UsernameChanged(msg.sender, _newUsername);
    }

    function getUsername(address _user) public view userExists(_user) returns (string memory) {
        return users[_user].username;
    }
}
