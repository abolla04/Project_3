pragma solidity ^0.5.0;

/*
Import the following contracts from the OpenZeppelin library and our SonatSonos:

* `Crowdsale`
* `MintedCrowdsale`
* `CappedCrowdsale`
* `TimedCrowdsale`

*/

import "./SonatSonos.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";

/*
Have Time Sensitive contract inherit the following from OpenZeppelin:
* `Crowdsale`
* `MintedCrowdsale`
* `CappedCrowdsale`
* `TimedCrowdsale`
*/
contract TimeSensitiveCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale{
	// sets a min and max in ether 
	//minimum - 2 ether
	//maximum - 50 ether
	uint256 public investorMinCap = 2000000000000000000;
	uint256 public investorHardCap = 50000000000000000000;

	mapping(address => uint256) public contributions;
	// Provide parameters for all the features of the crowdsale
	constructor(uint256 _rate,
	  address payable _wallet,
	  ERC20 _token,
	  uint256 _cap,
	  uint256 _openingTime,
	  uint256 _closingTime)
	Crowdsale(_rate, _wallet, _token)
	CappedCrowdsale(_cap)	
	TimedCrowdsale(_openingTime, _closingTime)
	public{
	}

//Define a `preValidatePurchase` function
  function _preValidatePurchase(
    address payable _beneficiary,
    uint256 _weiAmount
  )
    internal
  {
    super._preValidatePurchase(_beneficiary, _weiAmount);
    uint256 _existingContribution = contributions[_beneficiary];
    uint256 _newContribution = _existingContribution.add(_weiAmount);
    require(_newContribution >= investorMinCap && _newContribution <= investorHardCap);
	contributions[_beneficiary] = _newContribution;     
  }
}