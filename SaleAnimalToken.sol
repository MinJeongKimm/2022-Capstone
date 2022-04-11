// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./MintAnimalToken.sol";

contract SaleAnimalToken{
    MintAnimalToken public mintAnimalTokenAddress; //

    constructor (address _mintAnimalTokenAddress){
        mintAnimalTokenAddress = MintAnimalToken(_mintAnimalTokenAddress);
    }           // mintAnimalToken을 실행할때 나온 주소값을 mintAnimalTokenAddress에 넣어준다

    mapping(uint256 => uint256) public animalTokenPrices;  // animalTokeeid 입력하면 가격 나옴

    uint256[] public onSaleAnimalTokenArray; //프론트엔드에서 판매중인 토큰을 확인 할 수 있게 해주는 배열

    //판매 등록 함수, 팔것에 id, 가격 필요
    function setForSaleAnimalToken(uint256 _animalTokenId,uint256 _price) public {
        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId); // 토큰 아이디를 입력하면 해당하는 주인에 대한 값이 나옴

        require(animalTokenOwner ==msg.sender, "Caller is not animal token owner");  // animalTokenOwner ==msg.sender이 아니면 "Caller is not animal token owner"출력
        require(_price>0,"Price is zero or lower");  //_price>0이 아니면 "Price is zero or lower" 출력
        require(animalTokenPrices[_animalTokenId]==0,"This animal token is already on sale"); //(animalTokenPrices[_animalTokenId]==0이 아니면 "This animal token is already on sale"출력
        require(mintAnimalTokenAddress.isApprovedForAll(animalTokenOwner,address(this)),"Animal Token owner did not approve token"); //address(this) : saleanimaltoken의 스마트 컨트랙트 입력, 이 주인이 이 판매계약셔에 판매 권한을 넣었는지 확인

        animalTokenPrices[_animalTokenId] = _price;

        onSaleAnimalTokenArray.push(_animalTokenId); // 판매하는 배열로 푸쉬
    }

    //구매 함수
    function purchaseAnimalToken(uint256 _animalTokenId) public payable{  //payable있어야 메틱이 왔다갔다 하는 함수 실행 가능
        uint256 price =animalTokenPrices[_animalTokenId];
        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId); //주인의 주소값을 불러온다

        require(price>0,"Animal token not sale"); 
        require(price <=msg.value, "Caller sent lower than price"); // msg.value : 함수를 실행할때 보내는 메틱의 양(지불하는 돈)
        require(animalTokenOwner !=msg.sender,"Caller is animal token owner"); // 주인과 다른 사람이여야 구매가능

        payable(animalTokenOwner).transfer(msg.value); // msg.sender의 msg.value 만큼 토큰 주인에게 돈이 간다
        mintAnimalTokenAddress.safeTransferFrom(animalTokenOwner,msg.sender,_animalTokenId); // 3가지 인자(보내는 사람, 받는 사람, 뭘 보낼 것인가)

        animalTokenPrices[_animalTokenId] = 0; // 팔렸으니 판매 철회

        for(uint256 i =0;i<onSaleAnimalTokenArray.length;i++){
            if(animalTokenPrices[onSaleAnimalTokenArray[i]]==0){
                onSaleAnimalTokenArray[i]=onSaleAnimalTokenArray[onSaleAnimalTokenArray.length-1]; // 맨뒤에 있는 애를 i로 옮기고
                onSaleAnimalTokenArray.pop(); // 맨뒤 제거
            }
        }
    }

    // 판매중인 토큰 배열의 길이 출력하는 함수, 이걸 통해 for문을 돌려 프론트엔드에서 판매중인 리스트를 가져온다
    function getOnsaleAnimalTokenArrayLength() view public returns(uint256){
        return onSaleAnimalTokenArray.length;
    }
}