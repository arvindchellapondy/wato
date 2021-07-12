contract ATM {

    mapping(address => uint) public balances;

    event Deposit(address sender, uint amount);
    event Withdrawal(address receiver, uint amount);
    event Transfer(address sender, address receiver, uint amount);

    function deposit() public payable {
        emit Deposit(msg.sender, msg.value);
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint amount) public {
        require(balances[msg.sender] >= amount, "Insufficient funds");
        emit Withdrawal(msg.sender, amount);
        balances[msg.sender] -= amount;
    }

    // function transfer(address payable receiver, uint amount) payable public {
    //     require(balances[msg.sender] >= amount, "Insufficient funds");
    //     emit Transfer(msg.sender, receiver, amount);
    //     balances[msg.sender] -= amount;
    //     balances[receiver] += amount;
       
    // //    (bool sent, bytes memory data) = receiver.call{value: msg.value}("");
    // //     require(sent, "Failed to send Ether");

    //     bool sent = receiver.send(msg.value);
    //     require(sent, "Failed to send Ether");
    // }

    function getBalance(address addr) public view returns (uint){
        return balances[addr];
    }

    function sendEther(address payable recipient) external{
        recipient.transfer(1 ether);
    }

}