// mint 하는 함수
// SPDX-License-Identifier: MIT     //License 버전 명시 필요

pragma solidity ^0.8.0;  // 컴파일러 버전 명시 필요

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";   // nft를 정의하는 룰인 ERC721Eumerable 임포트

contract MintAnimalToken is ERC721Enumerable{
	constructor() ERC721("h662Animals","HAS") {}             //ERC721("name","symbol")

	mapping(uint256 => uint256) public animalTypes; // 앞쪽 uint256: animalTokenId, 뒤쪽 : animalTypes, animalTokenId를 입력하면 animalTypes가 나온다는 뜻

	function mintAnimalToken() public {
		uint256 animalTokenId = totalSupply()+1;     // 토큰아이디(유일한 값) = 지금까지 민팅된 nft 양 + 1

		uint256 animalType = uint256(keccak256(abi.encodePacked(block.timestamp,msg.sender,animalTokenId))) % 5 +1; // timestamp, msg.sender, animalTokenId 3가지 변수로 랜덤한 값(1~5)을 뽑아낸다.  1~5값으로 5가지 동물 카드 종류 표현

		animalTypes[animalTokenId] = animalType;

		_mint(msg.sender,animalTokenId); // 민트하는 함수(msg.sender는 이 명령어를 실행한 사람(민팅 누른 사람))
	}
}  