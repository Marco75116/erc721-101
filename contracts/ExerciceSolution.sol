pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Evaluator.sol";

contract ExerciceSolution is ERC721 {
    address evaluator;
    uint256 montantRegistrationPrice;
    uint256 numeroAnimal;
    address owner;

    struct animal {
        uint256 sex;
        uint256 legs;
        bool wings;
        string name;
    }

    mapping(uint256 => animal) registerAnimal;
    mapping(address => bool) registerBreeder;
    mapping(uint256 => uint256) registerAnimalPrice;

    constructor(
        string memory name_,
        string memory symbol_,
        address eval_
    ) public ERC721(name_, symbol_) {
        owner = msg.sender;
        evaluator = eval_;
        numeroAnimal = 1;
        montantRegistrationPrice = 10;
        _mint(evaluator, numeroAnimal);
        registerAnimal[numeroAnimal] = animal(0, 10, true, "toto");
    }

    function declareAnimal(
        uint256 sex,
        uint256 legs,
        bool wings,
        string calldata name
    ) external returns (uint256) {
        numeroAnimal += 1;
        _mint(msg.sender, numeroAnimal);
        registerAnimal[numeroAnimal] = animal(sex, legs, wings, name);
        return numeroAnimal;
    }

    function getAnimalCharacteristics(uint256 animalNumber)
        external
        view
        returns (
            string memory _name,
            bool _wings,
            uint256 _legs,
            uint256 _sex
        )
    {
        return (
            registerAnimal[animalNumber].name,
            registerAnimal[animalNumber].wings,
            registerAnimal[animalNumber].legs,
            registerAnimal[animalNumber].sex
        );
    }

    function isBreeder(address account) external view returns (bool) {
        if (registerBreeder[account]) {
            return true;
        } else {
            return false;
        }
    }

    function registrationPrice() external view returns (uint256) {
        return montantRegistrationPrice;
    }

    function registerMeAsBreeder() external payable {
        require(
            msg.value >= montantRegistrationPrice,
            "You did not send enough money!"
        );
        registerBreeder[msg.sender] = true;
    }

    function declareDeadAnimal(uint256 animalNumber) external {
        require(
            msg.sender == ownerOf(animalNumber),
            "you can't declare dead this animal cause you are not the owner."
        );
        delete registerAnimal[animalNumber];
        _burn(animalNumber);
        registerAnimal[animalNumber] = animal(0, 0, false, "");
    }

    function mint(address _to) public {
        require(msg.sender == owner, "you can't mint.");
        numeroAnimal += 1;
        ERC721._mint(_to, numeroAnimal);
        registerAnimal[numeroAnimal] = animal(0, 10, true, "owner");
    }

    function isAnimalExist(uint256 animalNumber) external view returns (bool) {
        animal memory a = registerAnimal[animalNumber];
        if (
            a.sex == 0 &&
            a.legs == 0 &&
            a.wings == false &&
            keccak256(abi.encodePacked(a.name)) ==
            keccak256(abi.encodePacked(""))
        ) {
            return false;
        } else {
            return true;
        }
    }

    function isAnimalForSale(uint256 animalNumber)
        external
        view
        returns (bool)
    {
        if (registerAnimalPrice[animalNumber] == 0) {
            return false;
        } else {
            return true;
        }
    }

    function animalPrice(uint256 animalNumber) external view returns (uint256) {
        return registerAnimalPrice[animalNumber];
    }

    function buyAnimal(uint256 animalNumber) external payable {
        require(
            registerAnimalPrice[animalNumber] != 0,
            "animal not for sale you know"
        );
        require(
            msg.value == registerAnimalPrice[animalNumber],
            "you have to send the rigth price of this animal"
        );
        registerAnimalPrice[animalNumber] = 0;
        // safeTransferFrom(ownerOf(animalNumber), address(this), animalNumber);
        // safeTransferFrom(ownerOf(animalNumber), msg.sender, animalNumber);
        // msg.sender.transfer(msg.value);
        // transferFrom(owner, address(this), animalNumber);
        // approve(evaluator, animalNumber);
        // transferFrom(address(this), evaluator, animalNumber);
        transferFrom(owner, evaluator, animalNumber);
        payable(owner).transfer(msg.value);
    }

    function offerForSale(uint256 animalNumber, uint256 price) external {
        require(
            ownerOf(animalNumber) == msg.sender,
            "you are not the owner of this animal"
        );
        // approve(address(this), animalNumber);
        // transferFrom(owner, address(this), animalNumber);
        approve(evaluator, animalNumber);
        registerAnimalPrice[animalNumber] = price;
    }

    function getOwnerof(uint256 nbAnimal) public view returns (address) {
        return ownerOf(nbAnimal);
    }
}
