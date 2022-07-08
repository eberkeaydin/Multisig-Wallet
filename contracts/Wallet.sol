pragma solidity 0.8.15;
pragma abicoder v2;

contract MultisigWallet {
    address[] public owners;
    uint limit;
    
    struct Transfer{
        uint amount;
        address payable receiver;
        uint approvals;
        bool hasBeenSent;
        uint id;
    }
    
    event TransferRequestsCreated(uint _id, uint _amount, address _initiator, address _receiver);
    event ApprovalRecieved(uint _id, uint _approvals, address _approver);
    event TransferApproved(uint _id);

    Transfer[] transferRequests;
    
    mapping(address => mapping(uint => bool)) approvals;
    
    //Should only allow people in the owners list to continue the execution.

    modifier onlyOwners(){ 
        bool _isOwner = false;
        for(uint i = 0; i < owners.length ; i++){
            if (owners[i] == msg.sender) {
                _isOwner = true;
                break;
            }
        }
        require(_isOwner == true, "Unauthorized");
        _; 
    }

    //Should initialize the owners list and the limit 
    // constructor(address[] memory _owners, uint _limit) {
    //     owners = _owners;
    //     limit = _limit;
    // }

    constructor(address owners1, address owners2, address owners3, uint _limit) {
        owners.push(owners1);
        owners.push(owners2);
        owners.push(owners3);
        limit = _limit;
    }
    
    //Empty function
    function deposit() public payable {}
    
    //Create an instance of the Transfer struct and add it to the transferRequests array

    function createTransfer(uint _amount, address payable _receiver) public onlyOwners {
        emit TransferRequestsCreated(transferRequests.length, _amount, msg.sender, _receiver);
        transferRequests.push(Transfer(_amount, _receiver, 0, false, transferRequests.length));
        

    }
    
    //Set your approval for one of the transfer requests.
    //Need to update the Transfer object.
    //Need to update the mapping to record the approval for the msg.sender.
    //When the amount of approvals for a transfer has reached the limit, this function should send the transfer to the recipient.
    //An owner should not be able to vote twice.
    //An owner should not be able to vote on a tranfer request that has already been sent.

    function approve(uint _id) public onlyOwners {
        require(approvals[msg.sender][_id] == false);
        require(transferRequests[_id].hasBeenSent == false);

        approvals[msg.sender][_id] = true;
        transferRequests[_id].approvals ++;

        emit ApprovalRecieved(_id, transferRequests[_id].approvals, msg.sender);

        if(transferRequests[_id].approvals >= limit) {
            transferRequests[_id].hasBeenSent = true;
            transferRequests[_id].receiver.transfer(transferRequests[_id].amount);
            emit TransferApproved(_id);
        }
    }
    
    //Should return all transfer requests

    function getTransferRequests() public view returns (Transfer[] memory){
        return transferRequests;
    }

    function balanceOf(address owner) public view returns (uint) { // This method used for return the total balance of token owner.
        return owner.balance;
    }
}