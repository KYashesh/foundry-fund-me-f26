// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

//constant, immutable are keywords which we will use for reducing gas.

//setting up custom errors
error FundMe_NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    //uint256 public myValue = 1;

    uint256 public constant MINIMUM_USD = 5e18;
    //21,415 gas - constant
    //23,515 gas - non constant
    //21,415 * 141000000000 = $9.0585
    //23,515 * 141000000000 = $9.9468

    address[] public s_funders;

    mapping(address funder => uint256 amountFunded)
        public s_addressToAmountFunded;

    address public immutable i_owner; // so that only owner can withdraw funds.

    //21,508 gas - immutable
    //23,644 gas - non immutable
    AggregatorV3Interface public s_priceFeed;

    constructor(address priceFeed) {
        s_priceFeed = AggregatorV3Interface(priceFeed);
        i_owner = msg.sender; // whoever deploys the contract is the owner.
    }

    function fund() public payable {
        //allows users to send $
        //myValue = myValue + 2;

        require(
            PriceConverter.getConversionRate(msg.value, s_priceFeed) >=
                MINIMUM_USD,
            "didn't send enough eth"
        );
        //1e18 = 1,000,000,000 Gwei = 1,000,000,000,000,000,000 wei

        //What is a revert?
        //undo any actions that have been done, and send the remaining gas back

        s_funders.push(msg.sender); // to keep track of funders.
        s_addressToAmountFunded[msg.sender] =
            s_addressToAmountFunded[msg.sender] +
            msg.value;
        //OR
        // addressToAmountFunded[msg.sender] += msg.value;
    }

    function cheaperWithdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length;
        for (
            uint256 funderIndex = 0;
            funderIndex < fundersLength;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0); //resetting the array.
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "call failed");
    }

    function withdraw() public {
        //for(/* starting index, ending index, step amount*/)
        // 0,10,1
        //1,2,3,4
        //require(msg.sender == owner, "Must be Owner"); we can use this as a modifier.

        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0); //resetting the array.
        //actually withdraw the funds. three ways:-
        //1. transfer
        // msg.sender = address
        //payable(msg.sender) = payable address
        //  {can be used in program}  payable(msg.sender).transfer(address(this).balance);

        //2. send
        //bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //require(sendSuccess, "send failed");

        //3. call
        (bool callSuccess /*bytes memory dataReturned */, ) = payable(
            msg.sender
        ).call{value: address(this).balance}("");
        require(callSuccess, "call failed");
    }

    // A Modifier is going to allow us to create a keyword that we can put right in the function declaration
    // to add some fuctionality very quickly and easily to any function.
    // used when we have a lot of admins, among them for only owner.
    //function getAddressToAmountFunded(address addr) public view returns(uint){}
    modifier onlyOwner() {
        //require(msg.sender == i_owner, "Sender is not the Owner.");
        if (msg.sender != i_owner) {
            revert FundMe_NotOwner();
        } // saves more or gas efficient.
        _;
    }

    //what if someone sends this contract ETH without calling the fund function?
    //use of special functions:- 1. receive 2. fallback
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    //if someone accidentally sends money without calling our fund function
    //it'll automatically route them over to the fund function.

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function getAddressToAmountFunded(
        address fundingAddress
    ) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }
}
