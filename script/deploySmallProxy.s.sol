// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {SmallProxy, ImplementationA, ImplementationB} from "../src/sublessons/SmallProxy.sol";

contract deploySmallProxy is Script {

    function run() public {
        SmallProxy proxy = new SmallProxy();
        ImplementationA implementationA = new ImplementationA();
        ImplementationB implementationB = new ImplementationB();
        proxy.setImplementation(address(implementationA));

        console.log("proxy: ", address(proxy));
        console.log("implementation: ", address(implementationA));
        console.log("implementation B: ", address(implementationB));


        uint256 value = proxy.readStorage();

        console.log("value initially without using getDataToTransact: ", value);

        proxy.getDataToTransact(30);
        value = proxy.readStorage();

        console.log("value after using getDataToTranasct:", value);

        proxy.setImplementation(address(implementationB));
        
        console.log("value after changing implementation:", value);


    }



}