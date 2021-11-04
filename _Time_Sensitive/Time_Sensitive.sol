pragma solidity ^0.5.0;

import "./SonatSonos.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";


contract TimeSensitiveCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale{

	//minimum investor Contribution - 2 ether
	//minimum investor Contribution - 50 ether
	uint256 public investorMinCap = 2000000000000000000;
	uint256 public investorHardCap = 50000000000000000000;

	mapping(address => uint256) public contributions;

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