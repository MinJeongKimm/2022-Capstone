// mint �ϴ� �Լ�
// SPDX-License-Identifier: MIT     //License ���� ��� �ʿ�

pragma solidity ^0.8.0;  // �����Ϸ� ���� ��� �ʿ�

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";   // nft�� �����ϴ� ���� ERC721Eumerable ����Ʈ

contract MintAnimalToken is ERC721Enumerable{
	constructor() ERC721("h662Animals","HAS") {}             //ERC721("name","symbol")

	mapping(uint256 => uint256) public animalTypes; // ���� uint256: animalTokenId, ���� : animalTypes, animalTokenId�� �Է��ϸ� animalTypes�� ���´ٴ� ��

	function mintAnimalToken() public {
		uint256 animalTokenId = totalSupply()+1;     // ��ū���̵�(������ ��) = ���ݱ��� ���õ� nft �� + 1

		uint256 animalType = uint256(keccak256(abi.encodePacked(block.timestamp,msg.sender,animalTokenId))) % 5 +1; // timestamp, msg.sender, animalTokenId 3���� ������ ������ ��(1~5)�� �̾Ƴ���.  1~5������ 5���� ���� ī�� ���� ǥ��

		animalTypes[animalTokenId] = animalType;

		_mint(msg.sender,animalTokenId); // ��Ʈ�ϴ� �Լ�(msg.sender�� �� ��ɾ ������ ���(���� ���� ���))
	}
}  