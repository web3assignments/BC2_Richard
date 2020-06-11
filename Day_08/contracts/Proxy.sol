pragma solidity ^0.6.0;

import "./Ownable.sol";

contract Proxy is Ownable {
    address public contractAddress;

    constructor(bytes memory code) public payable {
        createContract(code, msg.value);
    }

    function replaceContract(bytes memory code) public payable onlyOwner {
        (bool success, ) = contractAddress.call(
            abi.encodeWithSignature("destroy()")
        );
        require(success, "Deleting off old contract did not work out");

        createContract(code, address(this).balance);
    }

    function createContract(bytes memory code, uint256 eth) internal {
        address addr;
        assembly {
            addr := create(eth, add(code, 0x20), mload(code))
            if iszero(extcodesize(addr)) {
                revert(0, "Address not created")
            }
        }
        contractAddress = addr;
    }

    fallback() external payable {
        address implementation = contractAddress;
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(
                gas(),
                implementation,
                0,
                calldatasize(),
                0,
                0
            )
            returndatacopy(0, 0, returndatasize())
            switch result
                case 0 {
                    revert(0, returndatasize())
                }
                default {
                    return(0, returndatasize())
                }
        }
    }

    receive() external payable {
        (bool success, ) = contractAddress.call(
            abi.encodeWithSignature("receive()")
        );
        require(success, "function not executed successfully");
    }
}
