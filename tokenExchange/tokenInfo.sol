contract tokenInfo{
    address public owner;
    address public ownerContract;
    string public tokenName;
    uint public amountIssued;
    bool public isActive;
    struct holders {
        //address holder;
        uint amount;
        //uint expireTime;
        //bool isRecordExist;
    }
    mapping (address => holders) public holderMapping;
    address[] public holderList;
 
    //function tokenInfo(address _owner, string _tokenName, uint _amountIssued, uint _expireTime) {
    function tokenInfo(address _owner, string _tokenName, uint _amountIssued) {
        owner = _owner;
        ownerContract = msg.sender;
        tokenName = _tokenName;
        amountIssued = _amountIssued;
        isActive = true;
        //holderMapping[_owner] = holders(_amountIssued, _expireTime, true);
        holderMapping[_owner] = holders(_amountIssued);
        holderList.push(_owner);
    }
    
    modifier onlyOwner { if(msg.sender == owner) _;}
    modifier onlyOwnerContract { if(msg.sender == ownerContract) _;}
    
    /////////Functions issue/revoke token
    function issue(uint _amount) onlyOwnerContract {
        holderMapping[owner].amount += _amount;
    }
    
    function revoke() onlyOwnerContract {
        isActive = false;
    }
    
    /////////Functions update status of each token holders
    function update(address _giver, address _taker, uint _amount) onlyOwner returns (bool){
        if(_taker == 0x0){
            if(holderMapping[_giver].amount >= _amount){
                holderMapping[_giver].amount -= _amount;
                return true;
            }
            else return false;
        }
        
        if(holderMapping[_giver].amount >= _amount){
            holderMapping[_giver].amount -= _amount;
            holderMapping[_taker].amount += _amount;
            return true;
        }
        else return false;
    }
    
    
    
    /*
    function update(uint _type, address _giver, address _taker, uint _amount) onlyOwner returns (uint){
        //taker condition check
        if(!holderMapping[_taker].isRecordExist) {                                                //initialize if not exist
             holderMapping[_taker] = holders(0, 0, true);
             holderList.push(_taker);
        }
        if((holderMapping[_taker].expireTime < now) && (holderMapping[_taker].expireTime > 0)) {  //initialize if expire
            holderMapping[_taker].amount = 0;
            holderMapping[_taker].expireTime = 0;
        }
        
        if(_type == 1) {    //add
            uint giverExpireTime = holderMapping[_giver].expireTime;
            uint takerExpireTime = holderMapping[_taker].expireTime;
            if((giverExpireTime > now) && (holderMapping[_giver].amount >= _amount)){          //(1)if giver condition checked
                if(giverExpireTime >= takerExpireTime){                                     //(2)if giver's token last longer
                    if(takerExpireTime == 0) {                                              //(3)if taker doesn't have token
                        holderMapping[_taker].amount = _amount;
                    }
                    else {                                                                  //(3)if taker has token
                        holderMapping[_taker].amount = _amount + holderMapping[_taker].amount*(takerExpireTime-now)/(giverExpireTime-now);
                    }
                    holderMapping[_taker].expireTime = giverExpireTime;
                }
                else {                                                                      //(2)if taker's token last longer
                    holderMapping[_taker].amount += _amount*giverExpireTime/takerExpireTime;
                }
            }
            else return 0;                                                                  //return 0 for operation failure
            return 1;                                                                       //return 1 for operation success
        }
        else if(_type == 2) {   //sub
            if(holderMapping[_taker].amount < _amount) return 0;
            else {
                holderMapping[_taker].amount -= _amount;
                if(holderMapping[_taker].amount == 0) holderMapping[_taker].expireTime = 0;
                return 1;
            }
        }
        else return 0;
    }
    
    function expireCheck() onlyOwner {
        for(uint i = 0 ; i < holderList.length ; i++) {
            if(holderMapping[holderList[i]].expireTime <= now) {
                holderMapping[holderList[i]].amount = 0;
                holderMapping[holderList[i]].expireTime = 0;
            }
        }
    }
    */
    
}