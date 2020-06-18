pragma solidity ^0.6.0;

contract RoleControlled {
    enum Roles {FREE, USER, ADMIN, OWNER}
    mapping(address => Roles) public userRoles;

    modifier minimumRole(Roles role) {
        Roles senderRole = userRoles[msg.sender];

        if (role == Roles.FREE && senderRole != Roles.USER) {
          userRoles[msg.sender] = Roles.USER;
          _;
        }

        require (role <= senderRole, "You do not have the appropriate role for this action");
        _;
    }

    constructor() public payable {
      userRoles[msg.sender] = Roles.OWNER;
    }

    function setRole(Roles role, address user) public minimumRole(Roles.ADMIN) {
      userRoles[user] = role;
    }
}
