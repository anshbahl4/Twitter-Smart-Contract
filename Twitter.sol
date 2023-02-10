// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Twitter{

    struct Tweet{
        uint id;
        address author;
        uint createdAt;
        string content;
    }

    struct Message{
        uint id;
        address from;
        address to;
        string content;
        uint createdAt;
    }

    mapping(uint=>Tweet) tweets;
    mapping(address=>uint[]) private tweetsOf; //to store tweets
    mapping(address=>Message[]) conversation; //its not neccesary that sender will send only one message , so we made message{} like a dynamic array
    mapping(address=>address[]) followers;
    mapping(address=>mapping(address=>bool)) public operators;

    uint nextId;
    uint nextMessageId;

    function tweet(address _from,string memory _content) internal{
        require(msg.sender==_from || operators[msg.sender][_from]==true,"You are not Authorized to sned tweet");
        tweets[nextId]=Tweet(nextId,_from,block.timestamp,_content);
        tweetsOf[_from].push(nextId); //it will store id's of tweets that were tweeted from a particular address(user)
        nextId++;

    }

    function _sendMessage(address _from,address _to,string memory _content)internal{
    require(msg.sender==_from || operators[msg.sender][_from]==true,"You are not Authorized to send message");  //msg.sender is the person who called this smart contract and _from is the person who sent message
    conversation[_from].push(Message(nextMessageId,_from,_to,_content,block.timestamp));
    nextMessageId++;

    }

    function tweet(string calldata _content) public{
        tweet(msg.sender,_content);
    }

    function tweetFrom(address _from,string memory _content) public{
        tweet(_from,_content);
    }

    function _sendMessage(string memory _content,address _to) public{
        _sendMessage(msg.sender,_to,_content);
    }

    function sendMessageFrom(address _from,address _to,string memory _content)public {
        _sendMessage(_from,_to,_content);
    }

    function follow(address _followed) public { //followed means jise ham follow karna chahte ha
      followers[msg.sender].push(_followed);
    }
   
    function allow(address _operator) public{       //this function will define ham kisko kisko authority dena chahte ha
       operators[msg.sender][_operator]=true;
    }

    function disallow(address _operator) public{    //this function will define kis kis ko authority nhi deni aur kisse authority wapis leni ha
        operators[msg.sender][_operator]=false;
    }

    function getLatestTweet(uint count) public view returns(Tweet[] memory){
        require(count>0 && count<=nextId);
        Tweet[] memory memTweets = new Tweet[](count); //Initialized an empty array of size count
        uint j;
        for(uint i=nextId-count;i<nextId;i++){      //We will access latest tweets for ex- i=10-5;i<10;i++ 5 se lekar 10 tak ki saari tweets show karo
            Tweet storage _tweets=tweets[i]; 
            memTweets[j]=Tweet(_tweets.id,_tweets.author,_tweets.createdAt,_tweets.content);
            j++;
        }
         return memTweets;
    }
    
    function getTweetsOf(address user,uint count) public view returns(Tweet[]memory){
        require(count>0 &&count<=nextId,"Tweets not found");
        uint[] storage tweetsId=tweetsOf[user];
        Tweet[] memory _tweets=new Tweet[](count);
        uint j;
        for(uint i=tweetsId.length-count;i<tweetsId.length;i++){
            Tweet storage _tweet=tweets[tweetsId[i]];
        }


    }
    }