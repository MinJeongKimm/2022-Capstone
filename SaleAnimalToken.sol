// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./MintAnimalToken.sol";

contract SaleAnimalToken{
    MintAnimalToken public mintAnimalTokenAddress; //

    constructor (address _mintAnimalTokenAddress){
        mintAnimalTokenAddress = MintAnimalToken(_mintAnimalTokenAddress);
    }           // mintAnimalToken�� �����Ҷ� ���� �ּҰ��� mintAnimalTokenAddress�� �־��ش�

    mapping(uint256 => uint256) public animalTokenPrices;  // animalTokeeid �Է��ϸ� ���� ����

    uint256[] public onSaleAnimalTokenArray; //����Ʈ���忡�� �Ǹ����� ��ū�� Ȯ�� �� �� �ְ� ���ִ� �迭

    //�Ǹ� ��� �Լ�, �ȰͿ� id, ���� �ʿ�
    function setForSaleAnimalToken(uint256 _animalTokenId,uint256 _price) public {
        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId); // ��ū ���̵� �Է��ϸ� �ش��ϴ� ���ο� ���� ���� ����

        require(animalTokenOwner ==msg.sender, "Caller is not animal token owner");  // animalTokenOwner ==msg.sender�� �ƴϸ� "Caller is not animal token owner"���
        require(_price>0,"Price is zero or lower");  //_price>0�� �ƴϸ� "Price is zero or lower" ���
        require(animalTokenPrices[_animalTokenId]==0,"This animal token is already on sale"); //(animalTokenPrices[_animalTokenId]==0�� �ƴϸ� "This animal token is already on sale"���
        require(mintAnimalTokenAddress.isApprovedForAll(animalTokenOwner,address(this)),"Animal Token owner did not approve token"); //address(this) : saleanimaltoken�� ����Ʈ ��Ʈ��Ʈ �Է�, �� ������ �� �ǸŰ��ſ� �Ǹ� ������ �־����� Ȯ��

        animalTokenPrices[_animalTokenId] = _price;

        onSaleAnimalTokenArray.push(_animalTokenId); // �Ǹ��ϴ� �迭�� Ǫ��
    }

    //���� �Լ�
    function purchaseAnimalToken(uint256 _animalTokenId) public payable{  //payable�־�� ��ƽ�� �Դٰ��� �ϴ� �Լ� ���� ����
        uint256 price =animalTokenPrices[_animalTokenId];
        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId); //������ �ּҰ��� �ҷ��´�

        require(price>0,"Animal token not sale"); 
        require(price <=msg.value, "Caller sent lower than price"); // msg.value : �Լ��� �����Ҷ� ������ ��ƽ�� ��(�����ϴ� ��)
        require(animalTokenOwner !=msg.sender,"Caller is animal token owner"); // ���ΰ� �ٸ� ����̿��� ���Ű���

        payable(animalTokenOwner).transfer(msg.value); // msg.sender�� msg.value ��ŭ ��ū ���ο��� ���� ����
        mintAnimalTokenAddress.safeTransferFrom(animalTokenOwner,msg.sender,_animalTokenId); // 3���� ����(������ ���, �޴� ���, �� ���� ���ΰ�)

        animalTokenPrices[_animalTokenId] = 0; // �ȷ����� �Ǹ� öȸ

        for(uint256 i =0;i<onSaleAnimalTokenArray.length;i++){
            if(animalTokenPrices[onSaleAnimalTokenArray[i]]==0){
                onSaleAnimalTokenArray[i]=onSaleAnimalTokenArray[onSaleAnimalTokenArray.length-1]; // �ǵڿ� �ִ� �ָ� i�� �ű��
                onSaleAnimalTokenArray.pop(); // �ǵ� ����
            }
        }
    }

    // �Ǹ����� ��ū �迭�� ���� ����ϴ� �Լ�, �̰� ���� for���� ���� ����Ʈ���忡�� �Ǹ����� ����Ʈ�� �����´�
    function getOnsaleAnimalTokenArrayLength() view public returns(uint256){
        return onSaleAnimalTokenArray.length;
    }
}