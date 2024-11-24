// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Proxy} from "@openzeppelin/contracts/proxy/Proxy.sol";

contract SmallProxy is Proxy {
    // This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1
    // We use this slot to store the address of the implementation contract
    // The value is stored in the contract's storage at this position

    bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /**
     * @dev sets the implementation address in the slot
     * @param newImplementation the address of the new implementation
     */
    function setImplementation(address newImplementation) public {
        assembly {
            sstore(_IMPLEMENTATION_SLOT, newImplementation)
        }
    }

    /**
     * @dev returns the address stored in the slot
     * @return implementationAddress address of the implementation contract
     */
    function _implementation() internal view override returns (address implementationAddress) {
        // We use assembly to directly read the value from the storage slot
        assembly {
            implementationAddress := sload(_IMPLEMENTATION_SLOT)
        }
    }

    function getDataToTransact(uint256 numberToUpdate) public pure returns(bytes memory) {
        return abi.encodeWithSignature("setValue(uint256)", numberToUpdate);
    }

    function readStorage() public view returns(uint256 valueAtStorageSlotZero) {
        assembly {
            valueAtStorageSlotZero := sload(0)
        }
    }

}


// SmallProxy -> implementationA
contract ImplementationA {
    uint256 public value;

    function setValue(uint256 _value) public {
        value = _value;
    }
}


// SmallProxy -> implementationA
contract ImplementationB {
    uint256 public value;

    function setValue(uint256 _value) public {
        value = _value+2;
    }
}
